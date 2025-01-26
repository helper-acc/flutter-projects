import 'package:flutter/material.dart';
import 'package:lab02/database/mock_api_helper.dart';
import 'package:lab02/models/user.dart';
import 'package:lab02/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService with ChangeNotifier {
  late User _currentUser;
  bool _userExists = false;
  final MockApiHelper _apiService = MockApiHelper();  // Ініціалізація MockAPI

  User get currentUser => _currentUser;
  bool get userExists => _userExists;

  set userExists(bool value) {
    _userExists = value;
    notifyListeners();
  }

  UserService({User? user}) {
    if(user != null){
      _currentUser = user;
    }
  }

  Future<String> getUser(String email, String pass) async {
    String result = 'OK';
    try {
      _currentUser = await _apiService.getUserLoggedIn(email,pass);
      // Зберігаємо сесію в SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('autoLogin', true);
      await prefs.setString('email', email);
      notifyListeners();

    } catch(exception) {
      result = getReadableErrorMessage(exception.toString());
    }
    return result;
  }

  Future<String> isUserExists(String email) async {
    String result = 'OK';
    try {
      await _apiService.getUserByEmail(email);
      _userExists = true;
      notifyListeners();
    } catch(exception) {
      result = getReadableErrorMessage(exception.toString());
    }
    return result;
  }

  Future<String> insertUser(User user) async {
    String result = 'OK';
    try {
      await _apiService.insertUser(user);
      notifyListeners();
    } catch (exception) {
      result = getReadableErrorMessage(exception.toString());
    }
    return result;
  }

  Future<String> updateUser(String? name, String? phone, String? gender) async {
    String result = 'OK';
    if (name != null) {
      _currentUser.name = name;
    }
    if (phone != null) {
      _currentUser.phone = phone;
    }
    if (gender != null) {
      _currentUser.gender = gender;
    }
    try {
      // Якщо інтернет є, оновлюємо користувача через API
      await _apiService.updateUser(_currentUser);
      notifyListeners();
    } catch(exception) {
      result = getReadableErrorMessage(exception.toString());
    }
    return result;
  }

  Future<String> deleteUser() async {
    String result = 'OK';
    try {
      await _apiService.deleteUser(_currentUser.id);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('autoLogin');
      await prefs.remove('email');
    } catch(exception) {
      result = getReadableErrorMessage(exception.toString());
    }
    return result;
  }
}
