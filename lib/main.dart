import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'profile_screen.dart';
import 'choose_pizza_screen.dart';

void main() {
  runApp(const PizzaOrderingApp());
}

class PizzaOrderingApp extends StatelessWidget {
  const PizzaOrderingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Ordering App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/registration': (context) => RegistrationScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/main': (context) => const ChoosePizzaScreen(),
      },
    );
  }
}
