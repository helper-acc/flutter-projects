import 'package:flutter/material.dart';
import 'package:lab02/widgets/custom_text_field.dart';
import 'package:lab02/widgets/form_submit_button.dart';
import 'package:lab02/widgets/gender_dropdown_menu.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
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
        title: const Text('Персональні дані',
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
              Padding (
                padding: const EdgeInsets.only(bottom: 16),
                child: CustomTextField(
                  controller: nameController,
                  labelText: 'Ім\'я',
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
              Padding (
                padding: const EdgeInsets.only(bottom: 16),
                child: CustomTextField(
                  controller: phoneController,
                  labelText: 'Номер телефону',
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
              Padding (
                padding: const EdgeInsets.only(bottom: 32),
                child: GenderDropdownMenu(controller: genderController, ),
              ),
              FormSubmitButton(
                labelText: 'Продовжити',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushNamed(context, '/registration',
                      arguments: <String, String> {
                        'name': nameController.text.trim(),
                        'phone': phoneController.text.trim(),
                        'gender': genderController.text.trim(),
                      },
                    );
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
