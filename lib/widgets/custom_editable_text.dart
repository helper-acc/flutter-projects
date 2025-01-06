import 'package:flutter/material.dart';

class CustomEditableText extends StatefulWidget {
  const CustomEditableText({
    required this.title,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    super.key,
  });

  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String title;

  @override
  State<StatefulWidget> createState() => _CustomEditableTextState();
}

class _CustomEditableTextState extends State<CustomEditableText> {
  bool isReadOnly = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: isReadOnly,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      style: const TextStyle(fontSize: 18, color: Color(0xFF4E342E)),
      decoration: InputDecoration(
        labelText: widget.title,
        labelStyle: const TextStyle(fontSize: 18, color: Color(0xFF4E342E)),
        suffixIcon: IconButton(
          icon: isReadOnly
              ? const Icon(Icons.edit)
              : const Icon(Icons.check),
          color: const Color(0xFF4E342E),
          onPressed: () {
            setState(() {
              isReadOnly = !isReadOnly;
            });
          },
        ),
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
