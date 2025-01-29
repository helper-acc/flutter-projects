import 'package:flutter/material.dart';
import 'package:lab02/database/mock_api_helper.dart';
import 'package:lab02/models/user.dart';
import 'package:lab02/pages/login_page.dart';
import 'package:lab02/pages/pizza_order_page.dart';
import 'package:lab02/pages/profile_page.dart';
import 'package:lab02/pages/registration_page.dart';
import 'package:lab02/pages/user_info_page.dart';
import 'package:lab02/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  var autoLogin = prefs.getBool('autoLogin') ?? false;

  // Перевіряємо, чи існує користувач перед автологіном
  User? user;
  final MockApiHelper apiService = MockApiHelper();
  if (autoLogin) {
    final email = prefs.getString('email');
    if (email != null) {
      try {
        user = await apiService.getUserByEmail(email);
      } catch (exception) {
        // Користувача немає — скидаємо статус автологіну
        await prefs.remove('autoLogin');
        await prefs.remove('email');
        autoLogin = false;
      }
    }
  }
  runApp(PizzaOrderingApp(
    autoLogin: autoLogin,
    user: user,
  ));
}

class PizzaOrderingApp extends StatelessWidget {
  const PizzaOrderingApp({
    required this.autoLogin,
    required this.user,
    super.key,
  });

  final bool autoLogin;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserService(user: user)),
      ],
      child: MaterialApp(
        title: 'Pizza Ordering App',
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: autoLogin ? '/pizza_order' : '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/user_info': (context) => UserInfoPage(),
          '/registration': (context) => RegistrationPage(),
          '/profile': (context) => ProfilePage(),
          '/pizza_order': (context) => const PizzaOrderPage(),
        },
      ),
    );
  }
}
