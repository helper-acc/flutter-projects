import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab02/database/database_helper.dart';
import 'package:lab02/models/user.dart';

class MockApiHelper implements DatabaseHelper {
  final String baseUrl =
      'https://679403875eae7e5c4d908a18.mockapi.io/api/v1/users';

  // Отримуємо користувача за email
  @override
  Future<User> getUserByEmail(String email) async {
    final response = await http.get(Uri.parse('$baseUrl?email=$email'));
    final status = response.statusCode;
    if (status == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> data = jsonDecode(decodedResponse) as List<dynamic>;
      if (data.isNotEmpty) {
        return User.fromMap(data.first as Map<String, dynamic>);
      }
    } else if (status == 404) {
      throw Exception('$email not found.');
    }

    throw Exception('Status code: $status. Something went wrong..');
  }

  // Додаємо нового користувача через API
  @override
  Future<void> insertUser(User user) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toMap()),
    );
  }

  // Оновлюємо користувача
  @override
  Future<void> updateUser(User user) async {
    await http.put(
      Uri.parse('$baseUrl/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toMap()),
    );
  }

  @override
  Future<void> deleteUser(String id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }

  @override
  Future<User> getUserLoggedIn(String email, String password) async {
    final response = await http.get(
      Uri.parse('$baseUrl?email=$email'
          '&password=$password'),
    );
    final status = response.statusCode;
    if (status == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> data = jsonDecode(decodedResponse) as List<dynamic>;
      if (data.isNotEmpty) {
        return User.fromMap(data.first as Map<String, dynamic>);
      }
    } else if (status == 404) {
      throw Exception('$email not found.');
    }

    throw Exception('Status code: $status. Something went wrong..');
  }
}
