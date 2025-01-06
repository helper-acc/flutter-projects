import 'package:flutter/material.dart';

class FormSubmitButton extends StatelessWidget {
  const FormSubmitButton({
    required this.labelText,
    required this.onPressed,
    super.key,
  });

  final String labelText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFCC80),
        foregroundColor: const Color(0xFF4E342E),
        minimumSize: const Size(250, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(labelText,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

}
