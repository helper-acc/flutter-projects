import 'package:flutter/material.dart';

Widget buildPizzaItem(String title, String subtitle, IconData icon) {
  return Card(
    color: const Color(0xFFFFF3E0), // Пастельний фон для карточок
    child: ListTile(
      title: Text(title, style: const TextStyle(color: Color(0xFF4E342E))),
      subtitle: Text(subtitle, style:
      const TextStyle(color: Color(0xFF4E342E)),
      ),
      trailing: Icon(icon, color: const Color(0xFF4E342E)),
    ),
  );
}
