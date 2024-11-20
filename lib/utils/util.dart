String getReadableErrorMessage(String message) {
  if (message.contains('UNIQUE constraint failed')) {
    return 'Користувач з такою поштою вже існує.';
  }
  if (message.contains('not found')) {
    return 'Користувача не знайдено. Зареєструйтесь.';
  }
  return message;
}
