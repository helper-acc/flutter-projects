import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab02/bloc/login/login_state.dart';
import 'package:lab02/services/internet_service.dart';
import 'package:lab02/services/user_service.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserService userService;

  LoginCubit(this.userService) : super(LoginInitial());

  // Метод для авторизації користувача
  Future<void> loginUser(String email, String password) async {
    emit(LoginLoading());

    final hasInternet = await checkInternetConnection();
    if (!hasInternet) {
      emit(LoginFailure('Немає підключення до інтернету'));
      return;
    }

    try {
      final String result = await userService.getUser(email, password);
      if (result == 'OK') {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(result));
      }
    } catch (e) {
      emit(LoginFailure('Помилка під час авторизації'));
    }
  }

  // Метод для перевірки інтернету перед переходом на іншу сторінку
  Future<void> checkInternetAndNavigate({
    required VoidCallback onSuccess,
    required Function(String) onFailure,
  }) async {
    final hasInternet = await checkInternetConnection();
    if (hasInternet) {
      onSuccess();
    } else {
      onFailure('Немає підключення до інтернету');
    }
  }
}
