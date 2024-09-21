String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
RegExp emailRegex = RegExp(emailPattern);

bool isValidEmail(String email) {
  return emailRegex.hasMatch(email);
}
