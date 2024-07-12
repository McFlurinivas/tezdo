import 'package:flutter/material.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const EmailField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Enter your email';
        }
        if (!GetUtils.isEmail(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}
