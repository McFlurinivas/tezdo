import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view/sigup_page.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Business User?',
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
            ),
            Text(
              "Don't have an account",
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Login Here',
              style: TextStyle(
                  color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => const SignUpPage());
              },
              child: const Text(
                "Sign Up",
                style: TextStyle(
                    color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
