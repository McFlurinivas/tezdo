import 'package:flutter/material.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

class UsernameField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const UsernameField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Enter your username';
        }
        if (!GetUtils.isUsername(value)) {
          return 'Enter a valid username';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}
