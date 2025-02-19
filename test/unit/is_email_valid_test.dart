import 'package:flutter_test/flutter_test.dart';
import 'package:trilhas_phb/helpers/validators.dart';

void main() {
  group('Email Validation', () {
    test('Valid email addresses', () {
      expect(isEmailValid('test@example.com'), isTrue);
      expect(isEmailValid('user.name@domain.co'), isTrue);
      expect(isEmailValid('user_name123@sub.domain.net'), isTrue);
    });

    test('Invalid email addresses', () {
      expect(isEmailValid('invalid-email'), isFalse);
      expect(isEmailValid('missing@domain'), isFalse);
      expect(isEmailValid('missing@.com'), isFalse);
      expect(isEmailValid('@missingusername.com'), isFalse);
      expect(isEmailValid('user@domain,com'), isFalse);
      expect(isEmailValid('user@domain..com'), isFalse);
    });

    test('Edge cases', () {
      expect(isEmailValid(''), isFalse);
      expect(isEmailValid(' '), isFalse);
      expect(isEmailValid('a@b.c'), isTrue); // Minimum valid email
      expect(isEmailValid('user@domain.toolongtld'), isTrue); // Long TLDs are valid
    });
  });
}
