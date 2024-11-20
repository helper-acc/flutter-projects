import 'package:flutter/material.dart';
import 'package:lab02/models/user.dart';
import 'package:lab02/services/user_service.dart';
import 'package:lab02/widgets/custom_alert_dialog.dart';
import 'package:lab02/widgets/custom_editable_text.dart';
import 'package:lab02/widgets/custom_snack_bar.dart';
import 'package:lab02/widgets/form_submit_button.dart';
import 'package:lab02/widgets/gender_dropdown_menu.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Особисті дані', style:
          TextStyle(color: Color(0xFF4E342E)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final result = await showAlertDialog(
                context: context,
                title: 'Увага!',
                message: 'Ви дійсно бажаєте вийти з акаунта?',
              );
              if (!context.mounted) return;
              if (result == 'yes') {
                Navigator.pushNamedAndRemoveUntil(context, '/login',
                  ModalRoute.withName('/login'),
                );
              }
            },
          ),
        ],
        backgroundColor: const Color(0xFFFFCC80),
        iconTheme: const IconThemeData(color: Color(0xFF4E342E)),
      ),
      body: Center(
        child: Selector<UserService, User> (
          selector: (context, value) => value.currentUser,
          builder: (context, user, child) {
            nameController.text = user.name;
            phoneController.text = user.phone;
            genderController.text = user.gender;

            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text('Вітаємо, ${user.name}!',
                        style: const TextStyle(fontSize: 26,
                          color: Color(0xFF4E342E),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CustomEditableText(
                        title: 'Ім\'я',
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введіть ім\'я';
                          }
                          if (value.length < 4 || value.length > 20) {
                            return 'Дозволена кількість символів: від 4 до 20';
                          }
                          if (!value.contains(RegExp(r'^[A-Za-z]+$'))) {
                            return 'Дозволені лише літери (a-z)';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CustomEditableText(
                        title: 'Номер телефону',
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введіть номер телефону';
                          }
                          if (value.length != 12) {
                            return 'Дозволена кількість символів: 12';
                          }
                          if (!value.contains(RegExp(r'^[0-9]+$'))) {
                            return 'Дозволені лише цифри (0-9)';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: GenderDropdownMenu(controller: genderController),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: FormSubmitButton(
                        labelText: 'Зберегти зміни',
                        onPressed: () async {
                          if(_formKey.currentState!.validate()) {
                            final String result = await context
                                .read<UserService>()
                                .updateUser(
                              nameController.text.trim(),
                              phoneController.text.trim(),
                              genderController.text.trim(),
                            );
                            if (!context.mounted) return;
                            if (result == 'OK') {
                              setState(() {});
                              showSnackBar(context, 'Дані успішно оновлено!');
                            } else {
                              showSnackBar(context, result);
                            }
                          }
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final isLogout = await showAlertDialog(
                          context: context,
                          title: 'Увага!',
                          message: 'Ви дійсно бажаєте видалити акаунт?',
                        );
                        if (!context.mounted) return;
                        if (isLogout == 'yes') {
                          final result = await context
                              .read<UserService>()
                              .deleteUser();
                          if (!context.mounted) return;
                          if (result == 'OK') {
                            showSnackBar(context, 'Акаунт успішно видалено!');
                            Navigator.pushNamedAndRemoveUntil(context, '/login',
                              ModalRoute.withName('/login'),
                            );
                          } else {
                            showSnackBar(context, result);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF55E5E),
                        foregroundColor: const Color(0xFFFFFFFF),
                        minimumSize: const Size(250, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Видалити акаунт',
                        style: TextStyle(fontSize: 18,
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
