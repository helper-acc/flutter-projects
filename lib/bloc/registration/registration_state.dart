abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {}

class RegistrationFailure extends RegistrationState {
  final String errorMessage;

  RegistrationFailure(this.errorMessage);
}

class UserExists extends RegistrationState {
  final bool exists;

  UserExists(this.exists);
}
