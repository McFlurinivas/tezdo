import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tezdo/model/constants.dart';
import 'package:tezdo/model/errors.dart';
import 'package:tezdo/model/network/StatusController.dart';

class SplashController extends FSGetXController {
  String _user = '';
  String _pass = '';

  @override
  void onReady() {
    super.onReady();
    _validateLogin();
  }

  void _validateLogin() async {
    Future.delayed(const Duration(seconds: 3), () async {

      bool logged = await _isLogged();
      if (logged) {
        User? firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser != null) {
          Get.offAllNamed('/home');
        } else {
          if (TokenJwk.jwk.isEmpty) {
            if (_user.isEmpty && _pass.isEmpty) {
              Get.offAllNamed('/login');
            } else {
              JsonResponseToken response = await postToken(
                EndPoint.login,
                params: {
                  'username': _user.trim(),
                  'password': _pass.trim(),
                },
              );
              if (response.statusCode == 200) {
                TokenJwk.jwk = response.response!.token!;
                Get.offAllNamed('/home');
              } else {
                Errors().errors(response.statusCode);
                Get.offAllNamed('/login');
              }
            }
          } else {
            Get.offAllNamed('/home');
          }
        }
      } else {
        Get.offAllNamed('/login');
      }
    });
  }

  Future<bool> _isLogged() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _user = preferences.getString(persistence.user) ?? '';
    _pass = preferences.getString(persistence.pass) ?? '';
    return preferences.getBool(persistence.isLogged) ?? false;
  }
}
