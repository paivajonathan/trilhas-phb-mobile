import 'package:flutter_test/flutter_test.dart';
import 'package:trilhas_phb/helpers/calculators.dart';

void main() {
  group('calculateAge Tests', () {
    
    test('age when birthday has already passed this year', () {
      // Assume today is 2025-02-18
      final birthDate = DateTime(1990, 1, 1);  // Birthday passed this year
      final age = calculateAge(birthDate);
      expect(age, 35);  // Expected age as of 2025-02-18
    });

    test('age when birthday is today', () {
      final today = DateTime.now();
      final birthDate = DateTime(today.year, today.month, today.day);  // Birthday is today
      final age = calculateAge(birthDate);
      expect(age, 0);  // The person should be 0 years old if born today
    });

    test('age when birthday hasn’t happened yet this year', () {
      final birthDate = DateTime(1990, 12, 31);  // Birthday is later this year
      final age = calculateAge(birthDate);
      expect(age, 34);  // Expected age is 34, since birthday is in December
    });

    test('age when birthdate is in the future (should return negative or error)', () {
      final birthDate = DateTime(2050, 1, 1);  // Future birthdate
      final age = calculateAge(birthDate);
      expect(age, lessThan(0));  // The function should return negative or handle future date
    });
  });
}
