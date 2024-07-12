import 'package:flutter/material.dart';

class ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;
  final ValueChanged<String> onChanged;

  const ConfirmPasswordField({
    super.key,
    required this.controller,
    required this.passwordController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Confirm Password',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Confirm your password';
        }
        if (value != passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}
