import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:trilhas_phb/providers/user_data.dart';
import 'package:trilhas_phb/screens/authentication/registration/login_data.dart';
import 'package:trilhas_phb/screens/authentication/registration/personal_data.dart';

void main() {
  late Map<String, dynamic> sharedData;

  setUpAll(() async {
    await dotenv.load();
    sharedData = {
      "email": null,
      "password": null,
      "confirmPassword": null,
      "fullName": null,
      "birthDate": null,
      "phone": null,
      "neighborhoodName": null,
    };
  });

  testWidgets('LoginDataScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserDataProvider>(
            create: (context) => UserDataProvider(),
          ),
        ],
        child: MaterialApp(
          home: LoginData(
            sharedData: sharedData,
          ),
        ),
      ),
    );

    expect(find.text('Dados de Login'), findsOneWidget);
    expect(find.text('Insira seus dados de login abaixo'), findsOneWidget);
  });

  testWidgets('Field validation shows error on empty input',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserDataProvider>(
            create: (context) => UserDataProvider(),
          ),
        ],
        child: MaterialApp(
          home: LoginData(sharedData: sharedData),
        ),
      ),
    );

    final continueButtonFinder =
        find.byKey(const Key("logindatascreen_continuebutton"));
    await tester.ensureVisible(continueButtonFinder);
    await tester.pumpAndSettle();
    await tester.tap(continueButtonFinder);
    await tester.pumpAndSettle();

    // Check if validation error is shown
    expect(find.text('Digite um email.'), findsOneWidget);
    expect(find.text('Digite uma senha.'), findsOneWidget);
    expect(find.text('Confirme sua senha.'), findsOneWidget);
  });

  testWidgets('Continue button triggers navigation when form is valid',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserDataProvider>(
            create: (context) => UserDataProvider(),
          ),
        ],
        child: MaterialApp(
          home: LoginData(sharedData: sharedData,),
        ),
      ),
    );

    // Fill the form with valid input
    await tester.enterText(find.byType(TextFormField).at(0), "jose@gmail.com");
    await tester.enterText(find.byType(TextFormField).at(1), "123456");
    await tester.enterText(find.byType(TextFormField).at(2), "123456");

    // Tap the login button
    final continueButtonFinder = find.byKey(const Key("logindatascreen_continuebutton"));
    await tester.ensureVisible(continueButtonFinder);
    await tester.pumpAndSettle();
    await tester.tap(continueButtonFinder);
    await tester.pumpAndSettle();

    // Check if the navigation happened
    expect(find.byType(PersonalData), findsOneWidget);
  });
}
