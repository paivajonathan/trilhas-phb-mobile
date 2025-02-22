import 'package:flutter_test/flutter_test.dart';
import 'package:trilhas_phb/helpers/calculators.dart';

void main() {
  group('calculateAge Tests', () {
    test('age when birthday has already passed this year', () {
      final today = DateTime(2025, 02, 18);
      final birthDate = DateTime(1990, 1, 1);  // Birthday passed this year
      
      final age = calculateAge(birthDate, today);
      
      expect(age, 35);
    });

    test('age when birthday is today', () {
      final today = DateTime.now();
      final birthDate = DateTime(today.year, today.month, today.day);  // Birthday is today
      
      final age = calculateAge(birthDate);
      
      expect(age, 0);  // The person should be 0 years old if born today
    });

    test('age when birthday hasn’t happened yet this year', () {
      final today = DateTime(2025, 02, 18);
      final birthDate = DateTime(1990, 12, 31);  // Birthday is later this year
      
      final age = calculateAge(birthDate, today);
      
      expect(age, 34);  // Expected age is 34, since birthday is in December
    });

    test('age when birthdate is in the future', () {
      final today = DateTime(2025, 02, 18);
      final birthDate = DateTime(2050, 1, 1);  // Future birthdate
      
      final age = calculateAge(birthDate, today);
      
      expect(age, lessThan(0));
    });
  });
}
