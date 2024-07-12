import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tezdo/model/cart_item.dart';

class CartController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  final RxList<CartItem> _cartItems = <CartItem>[].obs;
  final RxBool isLoading = true.obs;

  List<CartItem> get cartItems => _cartItems;

  @override
  void onInit() {
    super.onInit();
    _user = _auth.currentUser;
    if (_user != null) {
      _loadCartItems();
    }
  }

  void _loadCartItems() async {
    isLoading.value = true;
    final snapshot = await _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('cart')
        .get();

    _cartItems.value = snapshot.docs
        .map((doc) => CartItem.fromDocument(doc))
        .toList();

    isLoading.value = false;
  }

  void increaseQuantity(CartItem cartItem) {
    cartItem.quantity++;
    _updateCartItem(cartItem);
  }

  void decreaseQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
      _updateCartItem(cartItem);
    }
  }

  void removeItem(CartItem cartItem) {
    _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('cart')
        .doc(cartItem.product.id.toString())
        .delete();

    _cartItems.remove(cartItem);
    _updateTotalPriceInFirebase();
  }

  void _updateCartItem(CartItem cartItem) {
    _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('cart')
        .doc(cartItem.product.id.toString())
        .update(cartItem.toMap());

    _cartItems[_cartItems.indexWhere((item) => item.product.id == cartItem.product.id)] = cartItem;
    _cartItems.refresh();
    _updateTotalPriceInFirebase();
  }

  void _updateTotalPriceInFirebase() async {
    double total = _cartItems.fold(0.0, (sum, item) => sum + (item.product.price ?? 0.0) * item.quantity);

    await _firestore
        .collection('users')
        .doc(_user!.uid)
        .update({'totalPrice': total});
  }

  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.product.price ?? 0.0) * item.quantity);
  }

  void goBackHome() {
    Get.back();
  }
}
