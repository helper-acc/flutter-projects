import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab02/bloc/profile/profile_state.dart';
import 'package:lab02/services/internet_service.dart';
import 'package:lab02/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserService userService;

  ProfileCubit(this.userService) : super(ProfileInitial());

  void loadUser() {
    emit(ProfileLoading());
    final user = userService.currentUser;
    if (user != null) {
      emit(ProfileLoaded(user));
    } else {
      emit(ProfileFailure('Не вдалося завантажити користувача.'));
    }
  }

  Future<void> updateUser(String name, String phone, String gender) async {
    emit(ProfileLoading());

    final hasInternet = await checkInternetConnection();
    if (!hasInternet) {
      emit(ProfileFailure('Немає підключення до інтернету.'));
      return;
    }

    final result = await userService.updateUser(name, phone, gender);
    if (result == 'OK') {
      final updatedUser = userService.currentUser;
      emit(ProfileLoaded(updatedUser)); // Залишаємо оновлений стан
      emit(ProfileSuccess('Дані успішно оновлено!')); // Для показу повідомлення
      emit(ProfileLoaded(updatedUser)); // Повертаємо оновлені дані
    } else {
      emit(ProfileFailure(result));
      final user = userService.currentUser;
      if (user != null) emit(ProfileLoaded(user)); // Відновлюємо попередні дані
    }
  }

  Future<void> deleteUser() async {
    emit(ProfileLoading());

    final hasInternet = await checkInternetConnection();
    if (!hasInternet) {
      emit(ProfileFailure('Немає підключення до інтернету.'));
      return;
    }

    final result = await userService.deleteUser();
    if (result == 'OK') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('autoLogin');
      await prefs.remove('email');
      emit(ProfileSuccess('Акаунт успішно видалено!'));
    } else {
      emit(ProfileFailure(result));
      final user = userService.currentUser;
      if (user != null) emit(ProfileLoaded(user)); // Відновлюємо попередні дані
    }
  }
}
