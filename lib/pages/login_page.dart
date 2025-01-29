import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab02/bloc/login/login_cubit.dart';
import 'package:lab02/bloc/login/login_state.dart';
import 'package:lab02/services/user_service.dart';
import 'package:lab02/widgets/custom_alert_dialog.dart';
import 'package:lab02/widgets/custom_text_field.dart';
import 'package:lab02/widgets/form_submit_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read<UserService>()),
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Логін',
                style: TextStyle(color: Color(0xFF4E342E)),
              ),
              backgroundColor: const Color(0xFFFFCC80),
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
                    BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if (state is LoginSuccess) {
                          showModalWindow(
                            context: context,
                            title: 'Повідомлення',
                            message: 'Вхід успішний!',
                          );
                          Navigator.popAndPushNamed(context, '/pizza_order');
                        } else if (state is LoginFailure) {
                          showModalWindow(
                            context: context,
                            title: 'Помилка',
                            message: state.errorMessage,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is LoginLoading) {
                          return const CircularProgressIndicator();
                        }

                        return FormSubmitButton(
                          labelText: 'Увійти',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginCubit>().loginUser(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                            }
                          },
                        );
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<LoginCubit>().checkInternetAndNavigate(
                              onSuccess: () =>
                                  Navigator.pushNamed(context, '/user_info'),
                              onFailure: (message) => showModalWindow(
                                context: context,
                                title: 'Помилка',
                                message: message,
                              ),
                            );
                      },
                      child: const Text(
                        'Зареєструватися',
                        style: TextStyle(color: Color(0xFF4E342E)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
