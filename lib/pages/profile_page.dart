import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab02/bloc/profile/profile_cubit.dart';
import 'package:lab02/bloc/profile/profile_state.dart';
import 'package:lab02/services/user_service.dart';
import 'package:lab02/widgets/custom_alert_dialog.dart';
import 'package:lab02/widgets/custom_editable_text.dart';
import 'package:lab02/widgets/custom_snack_bar.dart';
import 'package:lab02/widgets/form_submit_button.dart';
import 'package:lab02/widgets/gender_dropdown_menu.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileCubit(context.read<UserService>())..loadUser(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Особисті дані',
              style: TextStyle(color: Color(0xFF4E342E))),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final result = await showAlertDialog(
                  context: context,
                  title: 'Увага!',
                  message: 'Ви дійсно бажаєте вийти з акаунта?',
                );
                if (result == 'yes') {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', ModalRoute.withName('/login'));
                }
              },
            ),
          ],
          backgroundColor: const Color(0xFFFFCC80),
          iconTheme: const IconThemeData(color: Color(0xFF4E342E)),
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileFailure) {
              showModalWindow(
                  context: context,
                  title: 'Помилка',
                  message: state.errorMessage);
              final user = context.read<ProfileCubit>().userService.currentUser;
              if (user != null) {
                context.read<ProfileCubit>().emit(ProfileLoaded(user));
              }
            } else if (state is ProfileSuccess) {
              showSnackBar(context, state.message);
              if (state.message == 'Акаунт успішно видалено!') {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', ModalRoute.withName('/login'));
              }
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileLoaded) {
              final user = state.user;
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
                        child: Text(
                          'Вітаємо, ${user.name}!',
                          style: const TextStyle(
                              fontSize: 26, color: Color(0xFF4E342E)),
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<ProfileCubit>().updateUser(
                                    nameController.text.trim(),
                                    phoneController.text.trim(),
                                    genderController.text.trim(),
                                  );
                            }
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProfileCubit>().deleteUser();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF55E5E),
                          foregroundColor: const Color(0xFFFFFFFF),
                          minimumSize: const Size(250, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Видалити акаунт',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
