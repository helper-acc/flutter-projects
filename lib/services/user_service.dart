import 'package:flutter/material.dart';
import 'package:lab02/database/sqlite_helper.dart';
import 'package:lab02/models/user.dart';
import 'package:lab02/utils/util.dart';

class UserService with ChangeNotifier {
  late User _currentUser;
  bool _userExists = false;

  User get currentUser => _currentUser;
  bool get userExists => _userExists;

  set userExists(bool value) {
    _userExists = value;
    notifyListeners();
  }

  Future<String> getUser(String email, String pass) async {
    String result = 'OK';
    try {
      _currentUser = await SQLiteHelper.instance.getUserLoggedIn(email, pass);
      notifyListeners();
    } catch(exception) {
      result = getReadableErrorMessage(exception.toString());
    }
    return result;
  }

  Future<String> isUserExists(String email) async {
    String result = 'OK';
    try {
      await SQLiteHelper.instance.getUserByEmail(email);
    } catch(exception) {
      result = getReadableErrorMessage(exception.toString());
    }
    return result;
  }

  Future<String> insertUser(User user) async {
    String result = 'OK';
    try {
      await SQLiteHelper.instance.insertUser(user);
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
      await SQLiteHelper.instance.updateUser(_currentUser);
      notifyListeners();
    } catch(exception) {
      result = getReadableErrorMessage(exception.toString());
    }
    return result;
  }

  Future<String> deleteUser() async {
    String result = 'OK';
    try {
      await SQLiteHelper.instance.deleteUser(_currentUser.id);
    } catch(exception) {
      result = getReadableErrorMessage(exception.toString());
    }
    return result;
  }
}
