const String usersTable = 'users';

final class UserModel {
  static const columnId = '_id';
  static const columnEmail = 'email';
  static const columnName = 'name';
  static const columnPhone = 'phone';
  static const columnGender = 'gender';
  static const columnPassword = 'password';
  static const List<String> allColumns = [columnId, columnEmail, columnName,
    columnPhone, columnGender, columnPassword,];
}

class User {
  final int id;
  final String email;
  final String password;
  String name;
  String phone;
  String gender;

  User({
    required this.email,
    required this.name,
    required this.phone,
    required this.gender,
    required this.password,
    this.id = -1,
  });

  Map<String, Object?> toMap() => {
    UserModel.columnEmail: email,
    UserModel.columnName: name,
    UserModel.columnPhone: phone,
    UserModel.columnGender: gender,
    UserModel.columnPassword: password,
  };

  static User fromMap(Map<String, Object?> map) => User(
    id: map[UserModel.columnId] as int,
    email: map[UserModel.columnEmail] as String,
    name: map[UserModel.columnName] as String,
    phone: map[UserModel.columnPhone] as String,
    gender: map[UserModel.columnGender] as String,
    password: map[UserModel.columnPassword] as String,
  );
}
