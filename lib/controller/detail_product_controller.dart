import 'package:get/get.dart';
import 'package:tezdo/controller/home_controller.dart';
import 'package:tezdo/model/products.dart';

class DetailProductController extends GetxController {
  String id = '';
  late Product _product;
  final HomeController _homeController = Get.find<HomeController>();

  Product get product => _product;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments['id'] != null) {
      id = Get.arguments['id']!;
    }

    if (Get.arguments['product'] != null) {
      _product = Get.arguments['product'];
    }
  }

  void goBackHome() {
    Get.back();
  }

  bool isFavorite() {
    return _homeController.isFavorite(product);
  }

  void toggleFavorite() {
    _homeController.toggleFavorite(product);
    update();
  }

  void addToCart()  {
    _homeController.addToCart(product);
    Get.toNamed('/cart');
  }
}
