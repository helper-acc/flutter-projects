import 'package:flutter/material.dart';

Future<String?> showAlertDialog({
  required BuildContext context,
  required String title,
  required String message,
}) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: const TextStyle(color: Color(0xFF4E342E))),
        content: SingleChildScrollView(
          child: Text(message,
              style: const TextStyle(fontSize: 15, color: Color(0xFF4E342E)),
          ),
        ),
        backgroundColor: const Color(0xFFFFF3E0),
        actions: <Widget>[
          _createButton('Ні', () => Navigator.pop(context)),
          _createButton('Так', () => Navigator.pop(context, 'yes')),
        ],
      );
    },
  );
}

TextButton _createButton(String text, void Function()? onPressed) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      backgroundColor: const Color(0xFFFFCC80),
      foregroundColor: const Color(0xFF4E342E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: Text(text),
  );
}
