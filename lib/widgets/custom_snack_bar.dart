import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Container(
      alignment: Alignment.center,
      child: Text(message,
        style: const TextStyle(fontWeight: FontWeight.bold,
          color: Color(0xFF4E342E),
        ),
      ),
    ),
    duration: const Duration(milliseconds: 2500),
    elevation: 10,
    backgroundColor: const Color(0xFFFFCC80),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
