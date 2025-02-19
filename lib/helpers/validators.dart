import 'package:xml/xml.dart';

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

bool isGpxValid(String gpxString) {
  try {
    final document = XmlDocument.parse(gpxString);
    final root = document.rootElement;

    // Ensure root is <gpx> and contains valid elements
    if (root.name.local != 'gpx') return false;

    bool hasValidChild = root.findElements('wpt').isNotEmpty ||
                         root.findElements('rte').isNotEmpty ||
                         root.findElements('trk').isNotEmpty;

    return hasValidChild;
  } catch (e) {
    return false; // Invalid XML
  }
}
