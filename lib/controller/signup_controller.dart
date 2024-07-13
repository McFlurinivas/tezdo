import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tezdo/model/user.dart'; 

class SignUpController extends GetxController {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();

  bool _isCompleteForm = false;
  bool _isLoading = false;

  bool get isCompleteForm => _isCompleteForm;
  bool get isLoading => _isLoading;
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get controllerUsername => _controllerUsername;
  TextEditingController get controllerEmail => _controllerEmail;
  TextEditingController get controllerPassword => _controllerPassword;
  TextEditingController get controllerConfirmPassword => _controllerConfirmPassword;

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Enter your username";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Enter your email";
    }
    if (!GetUtils.isEmail(value)) {
      return "Enter a valid email.";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Enter your password.";
    }
    if (value.length < 8) {
      return "Your password must have at least 8 characters";
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Confirm your password.";
    }
    if (value != _controllerPassword.text) {
      return "Passwords do not match";
    }
    return null;
  }

  void _validateForm() {
    _isCompleteForm = _formKey.currentState?.validate() ?? false;
    update(['BtnSignUp']);
  }

  void onFieldChange(String? value) {
    _validateForm();
  }

  Future<void> onSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _isLoading = true;
    update(['BtnSignUp']);
    FocusScope.of(Get.context!).unfocus();//removes keyboard

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _controllerEmail.text.trim(),
        password: _controllerPassword.text.trim(),
      );

      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        username: _controllerUsername.text.trim(),
        email: _controllerEmail.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toJson());

      _signUpFinish(true);
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      _signUpFinish(false);
      Get.snackbar('Error', e.message ?? 'Failed to sign up');
    } catch (e) {
      _signUpFinish(false);
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      _isLoading = false;
      update(['BtnSignUp']);
    }
  }

  Future<void> _signUpFinish(bool success) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('IS_LOGGED', success);
    if (success) {
      preferences.setString('USER', _controllerUsername.text.trim());
      preferences.setString('EMAIL', _controllerEmail.text.trim());
    }
  }
}
