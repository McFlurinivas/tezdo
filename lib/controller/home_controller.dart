import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tezdo/view/category_products_page.dart';
import 'package:tezdo/model/constants.dart';
import 'package:tezdo/model/network/StatusController.dart';
import 'package:tezdo/model/products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController extends FSGetXController {
  final List<Product> _products = <Product>[].obs;
  List<Product> _allProducts = <Product>[];
  final RxBool _isLoading = true.obs;
  final RxBool _isAsc = false.obs;
  final _carouselIndex = 0.obs;
  final RxList<String> _categories = <String>[].obs;
  final RxString _selectedCategory = ''.obs;
  final RxList<Product> _favorites = <Product>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  List<Product> get products => _products;
  bool get isLoading => _isLoading.value;
  bool get isAsc => _isAsc.value;
  int get carouselIndex => _carouselIndex.value;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory.value;
  List<Product> get favorites => _favorites;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    _user = _auth.currentUser;
    if (_user != null) {
      await _loadFavorites();
      await _getProducts();
      await _getCategories();
    } else {
      Get.offAllNamed('/login');
    }
  }

  Future<void> _getProducts() async {
    JsonResponseList response = await getProducts(
      EndPoint.products,
      params: _isAsc.value ? {'sort': 'desc'} : {},
    );

    if (response.statusCode == 200) {
      _allProducts = response.response;
      _products.assignAll(_allProducts);
      update(['ListProducts']);
    }

    _isLoading.value = false;
    update();

    debugPrint('$response');
  }

  Future<void> _getCategories() async {
    JsonResponseListCategory response = await getCategories(
      EndPoint.categories,
    );

    if (response.statusCode == 200) {
      _categories.assignAll(
          response.response.map((category) => category.name).toList());
      update(['Categories']);
    }
  }

  Future<void> _loadFavorites() async {
    final userId = _user!.uid;
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();
    _favorites.value = snapshot.docs.map((doc) => Product.fromDocument(doc)).toList();
  }

  void filterProductsByCategory(String category) {
    _selectedCategory.value = category;
    if (category.isEmpty) {
      _products.assignAll(_allProducts);
    } else {
      _products.assignAll(_allProducts
          .where((product) => product.category == category)
          .toList());
    }
    update(['ListProducts']);
  }

  void onCategorySelected(String category) {
    _selectedCategory.value = category;
    Get.to(() => CategoryProductsPage(category: category));
  }

  void toggleFavorite(Product product) async {
    final userId = _user!.uid;
    if (_favorites.contains(product)) {
      _favorites.remove(product);
      await _removeFavoriteFromFirebase(userId, product);
    } else {
      _favorites.add(product);
      await _addFavoriteToFirebase(userId, product);
    }
    update(['favorites']);
  }

  void addToCart(Product product) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(product.id.toString())
          .set({...product.toMap(), "quantity": 1});
    }
  }

  Future<void> _addFavoriteToFirebase(String userId, Product product) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(product.id.toString())
        .set(product.toMap());
  }

  Future<void> _removeFavoriteFromFirebase(String userId, Product product) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(product.id.toString())
        .delete();
  }

  bool isFavorite(Product product) {
    return _favorites.contains(product);
  }

  void onChangeAsc() {
    _isAsc.value = !_isAsc.value;
    _isLoading.value = true;
    update();
    _getProducts();
  }

  void onCloseSession() {
    _auth.signOut().then((_) {
      SharedPreferences.getInstance().then((preferences) {
        preferences.setBool(persistence.isLogged, false);
        preferences.setString(persistence.user, '');
        preferences.setString(persistence.pass, '');
        Get.offAllNamed('/login');
      });
    });
  }

  void goToDetailProduct(String id, Product item) {
    Get.toNamed('/detail_product', arguments: {'id': id, 'product': item});
  }

  void onPageChanged(int index) {
    _carouselIndex.value = index;
  }
}
