import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:trilhas_phb/screens/authentication/login.dart';
import 'package:provider/provider.dart';
import 'package:trilhas_phb/providers/user_data.dart';
import 'package:trilhas_phb/screens/authentication/registration/personal_data.dart';
import 'package:trilhas_phb/services/auth.dart';
import 'package:mockito/mockito.dart';

import 'login_screen_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthService>()])
void main() {
  late MockAuthService mockAuthService;
  late Map<String, dynamic> sharedData;

  setUpAll(() async {
    await dotenv.load();

    mockAuthService = MockAuthService();
    AuthService.setMockInstance(mockAuthService);

    sharedData = {
      "email": "jose@gmail.com",
      "password": "123456",
      "confirmPassword": "123456",
      "fullName": null,
      "birthDate": null,
      "phone": null,
      "neighborhoodName": null,
    };
  });

  testWidgets('PersonalDataScreen renders correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserDataProvider>(
            create: (context) => UserDataProvider(),
          ),
        ],
        child: MaterialApp(
          home: PersonalData(sharedData: sharedData),
        ),
      ),
    );

    expect(find.text("Dados Pessoais"), findsOneWidget);
    expect(find.text("Insira seus dados pessoais abaixo"), findsOneWidget);
  });

  testWidgets('Field validation error on empty input',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserDataProvider>(
            create: (context) => UserDataProvider(),
          ),
        ],
        child: MaterialApp(
          home: PersonalData(sharedData: sharedData),
        ),
      ),
    );

    final registerButtonFinder = find.byKey(
      const Key("personaldatascreen_registerbutton"),
    );

    await tester.dragUntilVisible(
      registerButtonFinder,
      find.byType(ListView),
      const Offset(0, -1000),
      duration: Duration(seconds: 2),
    );
    await tester.pumpAndSettle();

    await tester.tap(registerButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text("Digite seu nome completo."), findsOneWidget);
    expect(find.text("Digite sua data de aniversário."), findsOneWidget);
    expect(find.text("Digite seu número de celular."), findsOneWidget);
  });

  testWidgets('Register button triggers register method when form is valid',
      (WidgetTester tester) async {
    when(mockAuthService.register(
      email: "jose@gmail.com",
      password: "123456",
      birthDate: "2005-07-18",
      cellphone: "86994717931",
      fullName: "Jose Silva",
      neighborhoodName: "Centro",
    )).thenAnswer((_) async {});

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserDataProvider>(
            create: (context) => UserDataProvider(),
          ),
        ],
        child: MaterialApp(
          home: PersonalData(
            sharedData: sharedData,
          ),
        ),
      ),
    );

    // Fill the form with valid input
    await tester.enterText(find.byType(TextFormField).at(0), "Jose Silva");
    await tester.enterText(find.byType(TextFormField).at(1), "18/07/2005");
    await tester.enterText(find.byType(TextFormField).at(2), "(86) 9 9471-7931");
    await tester.enterText(find.byType(TextFormField).at(3), "Centro");

    // Tap the register button

    final registerButtonFinder = find.byKey(
      const Key("personaldatascreen_registerbutton"),
    );

    await tester.dragUntilVisible(
      registerButtonFinder,
      find.byType(ListView),
      const Offset(0, -1000),
      duration: Duration(seconds: 2),
    );
    await tester.pumpAndSettle();

    await tester.tap(registerButtonFinder);
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
