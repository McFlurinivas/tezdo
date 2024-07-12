import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tezdo/controller/splash_controller.dart';
import 'package:tezdo/model/utils.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (_) {
        return Scaffold(
          body: Center(
            child: Image.asset(
              Utils().imageLogoAsset,
              width: 200,
              height: 200,
            ),
          ),
        );
      },
    );
  }
}
