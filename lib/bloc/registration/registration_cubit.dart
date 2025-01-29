import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab02/bloc/registration/registration_state.dart';
import 'package:lab02/models/user.dart';
import 'package:lab02/services/internet_service.dart';
import 'package:lab02/services/user_service.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final UserService userService;

  RegistrationCubit(this.userService) : super(RegistrationInitial());

  Future<void> checkUserExists(String email) async {
    emit(RegistrationLoading());

    try {
      final result = await userService.isUserExists(email);
      if (result == 'OK') {
        emit(UserExists(true));
      } else {
        emit(UserExists(false));
      }
    } catch (e) {
      emit(RegistrationFailure('Помилка під час перевірки користувача'));
    }
  }

  Future<void> registerUser(User user) async {
    emit(RegistrationLoading());

    final hasInternet = await checkInternetConnection();
    if (!hasInternet) {
      emit(RegistrationFailure('Немає підключення до інтернету'));
      return;
    }

    try {
      final result = await userService.insertUser(user);
      if (result == 'OK') {
        emit(RegistrationSuccess());
      } else {
        emit(RegistrationFailure(result));
      }
    } catch (e) {
      emit(RegistrationFailure('Помилка під час реєстрації'));
    }
  }
}
