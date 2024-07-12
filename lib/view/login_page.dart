import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezdo/controller/login_controller.dart';
import 'package:tezdo/widget/login/email_field.dart';
import 'package:tezdo/widget/login/footer.dart';
import 'package:tezdo/widget/login/password_field.dart';
import 'package:tezdo/widget/login/login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (_) {
        return Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Form(
                  key: _.formKey,
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
                        "Hi, Welcome Back!",
                        style: TextStyle(
                          color: Color(0xFF002a40),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      EmailField(controller: _.controllerName, onChanged: _.onChangeUserName,),
                      const SizedBox(height: 30),
                      PasswordField(controller: _.controllerPass, onChanged: _.onChangePass),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: Color(0xFF06699c),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GetBuilder<LoginController>(
                        id: 'BtnLogin',
                        builder: (_) {
                          return LoginButton(
                            isProcessing: _.isLoading,
                            onPressed: _.isCompleteForm
                                ? () => _.onLogin()
                                : () {
                                    _.formKey.currentState!.validate();
                                  },
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 20),
                      const Footer(),
                      const SizedBox(height: 20),
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
