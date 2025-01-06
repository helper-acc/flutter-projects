import 'package:lab02/models/user.dart';

abstract class DatabaseHelper {
  Future<int> insertUser(User user);
  Future<User> getUserByEmail(String email);
  Future<User> getUserLoggedIn(String email, String password);
  Future<int> updateUser(User user);
  Future<int> deleteUser(int id);
  Future<void> close();
}
