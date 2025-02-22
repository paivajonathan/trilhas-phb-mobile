// Mocks generated by Mockito 5.4.5 from annotations
// in trilhas_phb/test/widget/login_screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i5;
import 'package:trilhas_phb/models/user_data.dart' as _i2;
import 'package:trilhas_phb/services/auth.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeUserProfileModel_0 extends _i1.SmartFake
    implements _i2.UserProfileModel {
  _FakeUserProfileModel_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [AuthService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthService extends _i1.Mock implements _i3.AuthService {
  @override
  _i4.Future<_i2.UserProfileModel?> get userData =>
      (super.noSuchMethod(
            Invocation.getter(#userData),
            returnValue: _i4.Future<_i2.UserProfileModel?>.value(),
            returnValueForMissingStub:
                _i4.Future<_i2.UserProfileModel?>.value(),
          )
          as _i4.Future<_i2.UserProfileModel?>);

  @override
  _i4.Future<String> get token =>
      (super.noSuchMethod(
            Invocation.getter(#token),
            returnValue: _i4.Future<String>.value(
              _i5.dummyValue<String>(this, Invocation.getter(#token)),
            ),
            returnValueForMissingStub: _i4.Future<String>.value(
              _i5.dummyValue<String>(this, Invocation.getter(#token)),
            ),
          )
          as _i4.Future<String>);

  @override
  _i4.Future<void> logout() =>
      (super.noSuchMethod(
            Invocation.method(#logout, []),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<_i2.UserProfileModel> login({
    required String? email,
    required String? password,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#login, [], {#email: email, #password: password}),
            returnValue: _i4.Future<_i2.UserProfileModel>.value(
              _FakeUserProfileModel_0(
                this,
                Invocation.method(#login, [], {
                  #email: email,
                  #password: password,
                }),
              ),
            ),
            returnValueForMissingStub: _i4.Future<_i2.UserProfileModel>.value(
              _FakeUserProfileModel_0(
                this,
                Invocation.method(#login, [], {
                  #email: email,
                  #password: password,
                }),
              ),
            ),
          )
          as _i4.Future<_i2.UserProfileModel>);

  @override
  _i4.Future<void> register({
    required String? email,
    required String? password,
    required String? fullName,
    required String? birthDate,
    required String? cellphone,
    required String? neighborhoodName,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#register, [], {
              #email: email,
              #password: password,
              #fullName: fullName,
              #birthDate: birthDate,
              #cellphone: cellphone,
              #neighborhoodName: neighborhoodName,
            }),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<String> sendConfirmationCode({required String? email}) =>
      (super.noSuchMethod(
            Invocation.method(#sendConfirmationCode, [], {#email: email}),
            returnValue: _i4.Future<String>.value(
              _i5.dummyValue<String>(
                this,
                Invocation.method(#sendConfirmationCode, [], {#email: email}),
              ),
            ),
            returnValueForMissingStub: _i4.Future<String>.value(
              _i5.dummyValue<String>(
                this,
                Invocation.method(#sendConfirmationCode, [], {#email: email}),
              ),
            ),
          )
          as _i4.Future<String>);

  @override
  _i4.Future<String> checkConfirmationCode({
    required String? email,
    required String? confirmationCode,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#checkConfirmationCode, [], {
              #email: email,
              #confirmationCode: confirmationCode,
            }),
            returnValue: _i4.Future<String>.value(
              _i5.dummyValue<String>(
                this,
                Invocation.method(#checkConfirmationCode, [], {
                  #email: email,
                  #confirmationCode: confirmationCode,
                }),
              ),
            ),
            returnValueForMissingStub: _i4.Future<String>.value(
              _i5.dummyValue<String>(
                this,
                Invocation.method(#checkConfirmationCode, [], {
                  #email: email,
                  #confirmationCode: confirmationCode,
                }),
              ),
            ),
          )
          as _i4.Future<String>);

  @override
  _i4.Future<String> changePassword({
    required String? email,
    required String? confirmationCode,
    required String? newPassword,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#changePassword, [], {
              #email: email,
              #confirmationCode: confirmationCode,
              #newPassword: newPassword,
            }),
            returnValue: _i4.Future<String>.value(
              _i5.dummyValue<String>(
                this,
                Invocation.method(#changePassword, [], {
                  #email: email,
                  #confirmationCode: confirmationCode,
                  #newPassword: newPassword,
                }),
              ),
            ),
            returnValueForMissingStub: _i4.Future<String>.value(
              _i5.dummyValue<String>(
                this,
                Invocation.method(#changePassword, [], {
                  #email: email,
                  #confirmationCode: confirmationCode,
                  #newPassword: newPassword,
                }),
              ),
            ),
          )
          as _i4.Future<String>);

  @override
  _i4.Future<void> inactivateAccount() =>
      (super.noSuchMethod(
            Invocation.method(#inactivateAccount, []),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);
}
