import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab02/bloc/pizza_order/pizza_order_cubit.dart';
import 'package:lab02/models/user.dart';
import 'package:lab02/services/user_service.dart';
import 'package:lab02/widgets/build_pizza_item.dart';
import 'package:lab02/widgets/custom_alert_dialog.dart';
import 'package:provider/provider.dart';

class PizzaOrderPage extends StatelessWidget {
  const PizzaOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PizzaOrderCubit(), // Створення Cubit
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Pizza Ordering',
            style: TextStyle(color: Color(0xFF4E342E)),
          ),
          actions: [
            Selector<UserService, User>(
              selector: (context, value) => value.currentUser,
              builder: (context, value, child) {
                return Text(
                  value.email,
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
        body: BlocBuilder<PizzaOrderCubit, bool>(
          builder: (context, isOnline) {
            // Перевіряємо стан підключення до інтернету
            if (!isOnline) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showModalWindow(
                  context: context,
                  title: 'Увага!',
                  message: 'Відсутнє інтернет-з\'єднання',
                );
              });
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                buildPizzaItem(
                  'Margherita',
                  'Tomato, Mozzarella, Basil',
                  Icons.add,
                ),
                buildPizzaItem(
                  'Pepperoni',
                  'Tomato, Mozzarella, Pepperoni',
                  Icons.add,
                ),
                buildPizzaItem(
                  'BBQ Chicken',
                  'Chicken, BBQ Sauce, Onion',
                  Icons.add,
                ),
                buildPizzaItem(
                  'Ham & mushrooms',
                  'Mushrooms, Mozarella, Ham, X sauce',
                  Icons.add,
                ),
                buildPizzaItem(
                  'Pizza Salami',
                  'Salami, Mozarella, Onion',
                  Icons.add,
                ),
                buildPizzaItem(
                  'Beef and Crispy',
                  'Sweet peppe, BBQ sauce, Tomatoes, Pickled cucumbers,'
                      ' Mozarella, Crispy onion Beef',
                  Icons.add,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
