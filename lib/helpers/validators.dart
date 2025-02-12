bool isEmailValid(String email) {
  final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

  return emailValid;
}

bool isDecimalValid(String value, int maxDigits, int decimalPlaces) {
  List<String> parts = value.split('.');
  String integerPart = parts[0];
  String decimalPart = parts.length > 1 ? parts[1] : '';

  // Ensure decimal part is exactly `decimalPlaces` by padding if necessary
  decimalPart = decimalPart.padRight(decimalPlaces, '0');

  // Ensure total digits do not exceed maxDigits
  if ((integerPart.length + decimalPart.length) > maxDigits) {
    return false;
  }

  return true;
}
