import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const PasswordField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Enter your password';
        }
        if (value.length < 8) {
          return 'Your password must have at least 8 characters';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}
