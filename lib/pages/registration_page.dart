import 'package:flutter/material.dart';
import 'package:lab02/models/user.dart';
import 'package:lab02/services/user_service.dart';
import 'package:lab02/widgets/custom_snack_bar.dart';
import 'package:lab02/widgets/custom_text_field.dart';
import 'package:lab02/widgets/form_submit_button.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ModalRoute.of(context)!
        .settings.arguments as Map<String, String>;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Реєстрація',
          style: TextStyle(color: Color(0xFF4E342E)),
        ),
        backgroundColor: const Color(0xFFFFCC80),
        iconTheme: const IconThemeData(color: Color(0xFF4E342E)),
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
                child: Focus(
                  onFocusChange: (value) async {
                    if (!value) {
                      final String result = await context
                          .read<UserService>()
                          .isUserExists(emailController.text.trim());
                      if (!context.mounted) return;
                      if (result == 'OK') {
                        context.read<UserService>().userExists = true;
                      } else {
                        context.read<UserService>().userExists = false;
                        if (!result.contains('Користувача не знайдено.'
                            ' Зареєструйтесь.')) {
                          showSnackBar(context, result);
                        }
                      }
                    }
                  },
                  child: Selector<UserService, bool>(
                    selector: (context, userExists) => userExists.userExists,
                    builder: (context, userExists, child) {
                      return CustomTextField(
                        controller: emailController,
                        labelText: 'Пошта',
                        keyboardType: TextInputType.emailAddress,
                        errorText: userExists ? 'Користувач з такою'
                            ' поштою вже існує.' : null,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введіть пошту';
                          }
                          if (value.length < 6 || value.length > 30) {
                            return 'Дозволена кількість символів: від 6 до 30';
                          }
                          if (!value.contains(RegExp(r'^[a-z0-9@.]+$'))) {
                            return 'Дозволені лише літери (a-z), цифри (0-9) '
                                'та крапки (.)';
                          }
                          if (!value.contains('@')) {
                            return 'Пошта повинна містити знак \'@\'';
                          }
                          if (!value.contains('.')) {
                            return 'Пошта повинна містити знак \'.\'';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CustomTextField(
                  controller: passController,
                  labelText: 'Пароль',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введіть пароль';
                    }
                    if (value.length < 6 || value.length > 30) {
                      return 'Дозволена кількість символів: від 6 до 30';
                    }
                    return null;
                  },
                ),
              ),
              Padding (
                padding: const EdgeInsets.only(bottom: 32),
                child: CustomTextField(
                  controller: confirmPassController,
                  labelText: 'Підтвердьте пароль',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Підтвердьте пароль';
                    }
                    if (value != passController.text) {
                      return 'Ці паролі не збігаються. Повторіть спробу.';
                    }
                    return null;
                  },
                ),
              ),
              FormSubmitButton(
                labelText: 'Зареєструватися',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final User user = User(
                      email: emailController.text.trim(),
                      name: userInfo['name']!,
                      phone: userInfo['phone']!,
                      gender: userInfo['gender']!,
                      password: passController.text.trim(),
                    );
                    final String result = await context
                        .read<UserService>()
                        .insertUser(user);
                    if (!context.mounted) return;
                    if (result == 'OK') {
                      showSnackBar(context, 'Реєстрація успішна!');
                    } else {
                      showSnackBar(context, result);
                    }
                    Navigator.popUntil(context, ModalRoute.withName('/login'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
