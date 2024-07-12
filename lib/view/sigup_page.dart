import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezdo/controller/signup_controller.dart';
import 'package:tezdo/widget/login/email_field.dart';
import 'package:tezdo/widget/login/password_field.dart';
import 'package:tezdo/widget/signup/sigup_button.dart';
import 'package:tezdo/widget/signup/username_field.dart';
import 'package:tezdo/widget/signup/confirm_password_field.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      init: SignUpController(),
      builder: (controller) {
        return Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Form(
                  key: controller.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      const Text(
                        "Tezdo",
                        style: TextStyle(
                          color: Color(0xFF002a40),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Create a new account",
                        style: TextStyle(
                          color: Color(0xFF002a40),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      UsernameField(
                        controller: controller.controllerUsername,
                        onChanged: controller.onFieldChange,
                      ),
                      const SizedBox(height: 20),
                      EmailField(
                        controller: controller.controllerEmail,
                        onChanged: controller.onFieldChange,
                      ),
                      const SizedBox(height: 20),
                      PasswordField(
                        controller: controller.controllerPassword,
                        onChanged: controller.onFieldChange,
                      ),
                      const SizedBox(height: 20),
                      ConfirmPasswordField(
                        controller: controller.controllerConfirmPassword,
                        passwordController: controller.controllerPassword,
                        onChanged: controller.onFieldChange,
                      ),
                      const SizedBox(height: 20),
                      GetBuilder<SignUpController>(
                        id: 'BtnSignUp',
                        builder: (controller) {
                          return SigninButton(
                            isProcessing: controller.isLoading,
                            onPressed: controller.isCompleteForm ? controller.onSignUp : () {
                              controller.formKey.currentState!.validate();
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "By continuing, you agree to",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Tezdo's ",
                              style: TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                            TextSpan(
                              text: "Terms of Use & Privacy Policy.",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
