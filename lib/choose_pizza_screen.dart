import 'package:flutter/material.dart';

class ChoosePizzaScreen extends StatelessWidget {
  const ChoosePizzaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizza Ordering', style: TextStyle(color: Color(0xFF4E342E))),
        backgroundColor: const Color(0xFFFFCC80),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          buildPizzaItem('Margherita', 'Tomato, Mozzarella, Basil', Icons.add),
          buildPizzaItem('Pepperoni', 'Tomato, Mozzarella, Pepperoni', Icons.add),
          buildPizzaItem('BBQ Chicken', 'Chicken, BBQ Sauce, Onion', Icons.add),
        ],
      ),
    );
  }

  Widget buildPizzaItem(String title, String subtitle, IconData icon) {
    return Card(
      color: const Color(0xFFFFF3E0), // Пастельний фон для карточок
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Color(0xFF4E342E))),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF4E342E))),
        trailing: Icon(icon, color: const Color(0xFF4E342E)),
      ),
    );
  }
}
