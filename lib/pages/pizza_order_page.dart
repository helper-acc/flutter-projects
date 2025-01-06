import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lab02/models/user.dart';
import 'package:lab02/services/user_service.dart';
import 'package:lab02/widgets/build_pizza_item.dart';
import 'package:lab02/widgets/custom_alert_dialog.dart';
import 'package:provider/provider.dart';

class PizzaOrderPage extends StatefulWidget {
  const PizzaOrderPage({super.key});

  @override
  State<StatefulWidget> createState() => _PizzaOrderState();
}

class _PizzaOrderState extends State<PizzaOrderPage> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isOnline = result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi);
      });
      if (!_isOnline) {
        showModalWindow(context: context,
            title: 'Увага!',
            message: 'Відсутнє інтернет-з\'єднання', );
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizza Ordering',
            style: TextStyle(color: Color(0xFF4E342E)),
        ),
        actions: [
          Selector<UserService, User>(
            selector: (context, value) => value.currentUser,
            builder: (context, value, child) {
              return Text(value.email,
                style: const TextStyle(color: Color(0xFF4E342E)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
        backgroundColor: const Color(0xFFFFCC80),
        iconTheme: const IconThemeData(color: Color(0xFF4E342E)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildPizzaItem('Margherita',
            'Tomato, Mozzarella, Basil',
            Icons.add,
          ),
          buildPizzaItem('Pepperoni',
            'Tomato, Mozzarella, Pepperoni',
            Icons.add,
          ),
          buildPizzaItem('BBQ Chicken',
              'Chicken, BBQ Sauce, Onion',
              Icons.add,
          ),
        ],
      ),
    );
  }
}
