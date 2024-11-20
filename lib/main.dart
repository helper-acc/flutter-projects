import 'package:flutter/material.dart';
import 'package:lab02/pages/login_page.dart';
import 'package:lab02/pages/pizza_order_page.dart';
import 'package:lab02/pages/profile_page.dart';
import 'package:lab02/pages/registration_page.dart';
import 'package:lab02/pages/user_info_page.dart';
import 'package:lab02/services/user_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const PizzaOrderingApp());
}

class PizzaOrderingApp extends StatelessWidget {
  const PizzaOrderingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserService()),
      ],
      child: MaterialApp(
        title: 'Pizza Ordering App',
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/user_info': (context) => const UserInfoPage(),
          '/registration': (context) => const RegistrationPage(),
          '/profile': (context) => const ProfilePage(),
          '/pizza_order': (context) => const PizzaOrderPage(),
        },
      ),
    );
  }
}
