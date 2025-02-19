import 'package:flutter_test/flutter_test.dart';
import 'package:trilhas_phb/helpers/validators.dart';

void main() {
  group('Decimal Validation', () {
    test('Valid decimal numbers', () {
      expect(isDecimalValid('123.45', 5, 2), isTrue);
      expect(isDecimalValid('99.9', 4, 1), isTrue);
      expect(isDecimalValid('100', 3, 0), isTrue);
    });

    test('Invalid decimal numbers', () {
      expect(isDecimalValid('123.456', 5, 2), isFalse); // Exceeds maxDigits
      expect(isDecimalValid('1000', 3, 0), isFalse); // Exceeds maxDigits
      expect(isDecimalValid('12.345', 4, 2), isFalse); // Too many decimal places
    });

    test('Edge cases', () {
      expect(isDecimalValid('0', 1, 0), isTrue);
      expect(isDecimalValid('0.0', 2, 1), isTrue);
      expect(isDecimalValid('0.00', 3, 2), isTrue);
      expect(isDecimalValid('0.000', 3, 2), isFalse); // Exceeds allowed decimal places
    });
  });
}
