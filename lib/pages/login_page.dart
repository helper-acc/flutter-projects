import 'package:flutter/material.dart';
import 'package:lab02/services/user_service.dart';
import 'package:lab02/widgets/custom_snack_bar.dart';
import 'package:lab02/widgets/custom_text_field.dart';
import 'package:lab02/widgets/form_submit_button.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Логін',
            style: TextStyle(color: Color(0xFF4E342E)),
        ),
        backgroundColor: const Color(0xFFFFCC80), // Пастельний помаранчевий
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CustomTextField(
                  controller: emailController,
                  labelText: 'Пошта',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введіть пошту';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: CustomTextField(
                  controller: passwordController,
                  labelText: 'Пароль',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введіть пароль';
                    }
                    return null;
                  },
                ),
              ),
              FormSubmitButton(
                labelText: 'Увійти',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final String result = await context
                        .read<UserService>()
                        .getUser(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                    if (!context.mounted) return;
                    if (result == 'OK') {
                      showSnackBar(context, 'Вхід успішний!');
                      Navigator.popAndPushNamed(context, '/pizza_order');
                    } else {
                      showSnackBar(context, result);
                    }
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/user_info');
                },
                child: const Text('Зареєструватися',
                  style: TextStyle(color: Color(0xFF4E342E)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
