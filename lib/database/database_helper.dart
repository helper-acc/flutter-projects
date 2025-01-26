import 'package:lab02/models/user.dart';

abstract class DatabaseHelper {
  Future<void> insertUser(User user);
  Future<User> getUserByEmail(String email);
  Future<User> getUserLoggedIn(String email, String password);
  Future<void> updateUser(User user);
  Future<void> deleteUser(String id);
}
