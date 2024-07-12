import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tezdo/model/constants.dart';

class LoginController extends GetxController {
  bool _isCompleteForm = false;
  bool _isVisibilityPass = false;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();

  bool get isCompleteForm => _isCompleteForm;
  bool get isVisibilityPass => _isVisibilityPass;
  bool get isLoading => _isLoading;
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get controllerName => _controllerName;
  TextEditingController get controllerPass => _controllerPass;

  void changePasswordVisibility() {
    _isVisibilityPass = !_isVisibilityPass;
    update(['Password']);
  }

  String? validateUserName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Enter your username";
    } else if (!GetUtils.isUsername(value)) {
      return "Enter a valid username.";
    }
    return null;
  }

  String? validatePass(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Enter your password.";
    }
    if (value.trim().length < 8) {
      return "Your password must have at least 8 digits";
    }
    return null;
  }

  void onChangeUserName(String? value) {
    _validateForm();
  }

  void onChangePass(String? value) {
    _validateForm();
  }

  void _validateForm() {
    _isCompleteForm = _formKey.currentState?.validate() ?? false;
    update(['BtnLogin']);
  }

  Future<void> onLogin() async {
    _isLoading = true;
    update(['BtnLogin']);
    FocusScope.of(Get.context!).requestFocus(FocusNode());

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _controllerName.text.trim(),
        password: _controllerPass.text.trim(),
      );

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userSnapshot.exists) {
        _loginFinish(true);
        Get.offAllNamed('/home');
      } else {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User not found in database.',
        );
      }
    } on FirebaseAuthException catch (e) {
      _loginFinish(false);
      Get.snackbar('Oops!', e.message ?? 'Invalid username or password');
    } finally {
      _isLoading = false;
      update(['BtnLogin']);
    }
  }

  void goToSignIn() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    Get.toNamed('/signin');
  }

  Future<void> _loginFinish(bool success) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(persistence.isLogged, success);
    preferences.setBool(persistence.isGuest, !success);
    preferences.setString(persistence.user, _controllerName.text.trim());
    preferences.setString(persistence.pass, _controllerPass.text.trim());
  }
}
