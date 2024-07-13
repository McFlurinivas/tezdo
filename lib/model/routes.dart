import 'package:get/get.dart';
import 'package:tezdo/view/cart_page.dart';
import 'package:tezdo/view/detail_product_page.dart';
import 'package:tezdo/view/home_page.dart';
import 'package:tezdo/view/login_page.dart';
import 'package:tezdo/view/sigup_page.dart';
import 'package:tezdo/view/splash_page.dart';

final routes = [
  GetPage(
    name: '/',
    page: () => const SplashPage(),
    transition: Transition.circularReveal,
  ),
  GetPage(
    name: '/singin',
    page: () => const SignUpPage(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: '/login',
    page: () => const LoginPage(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: '/home',
    page: () => const HomePage(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: '/detail_product',
    page: () => const DetailProductPage(),
    transition: Transition.circularReveal,
    transitionDuration: const Duration(
      milliseconds: 50,
    ),
  ),
  GetPage(
    name: '/cart',
    page: () => const CartPage(),
    transition: Transition.circularReveal,
    fullscreenDialog: true,
  ),
];
