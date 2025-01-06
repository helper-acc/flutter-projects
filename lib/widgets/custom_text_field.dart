import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.controller,
    this.labelText,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    super.key,
  });

  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? labelText;
  final String? errorText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      style: const TextStyle(color: Color(0xFF4E342E)),
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        labelStyle: const TextStyle(color: Color(0xFF4E342E)),
        filled: true,
        fillColor: const Color(0xFFFFF3E0), // Пастельний фон для полів
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

}
