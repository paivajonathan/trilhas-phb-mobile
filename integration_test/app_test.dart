import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trilhas_phb/main.dart';
import 'package:trilhas_phb/screens/authentication/login.dart';
import 'package:trilhas_phb/screens/authentication/registration/login_data.dart';
import 'package:trilhas_phb/screens/authentication/registration/personal_data.dart';
import 'package:trilhas_phb/screens/navigation_wrapper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App starts and shows home screen', (WidgetTester tester) async {
    await dotenv.load();
    await tester.pumpWidget(const MainApp()); // Replace with your main widget
    await tester.pumpAndSettle();

    expect(find.text('Bem Vindo(a)!'), findsOneWidget); // Adjust based on UI
  });

  testWidgets('Login successfull', (WidgetTester tester) async {
    await dotenv.load();
    await tester.pumpWidget(const MainApp()); // Replace with your main widget
    await tester.pumpAndSettle();

    expect(find.text('Bem Vindo(a)!'), findsOneWidget); // Adjust based on UI

    await tester.enterText(find.byType(TextFormField).at(0), "admin@gmail.com");
    await tester.tap(find.byKey(Key("loginscreen_scaffold")));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(1), "123456");
    await tester.tap(find.byKey(Key("loginscreen_scaffold")));
    await tester.pumpAndSettle();

    // Tap the login button
    final registerButtonFinder = find.byKey(
      const Key("loginscreen_loginbutton"),
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

    // Check if the navigation happened
    expect(find.byType(NavigationWrapper), findsOneWidget);

    await tester.tap(find.byKey(Key("mainbottomnavigation_profile")));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("profilescreen_leavetext")));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("dialogwidget_confirmbutton")));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Login successfull hiker', (WidgetTester tester) async {
    await dotenv.load();
    await tester.pumpWidget(const MainApp()); // Replace with your main widget
    await tester.pumpAndSettle();

    expect(find.text('Bem Vindo(a)!'), findsOneWidget); // Adjust based on UI

    await tester.enterText(find.byType(TextFormField).at(0), "jonathanapaiva@gmail.com");
    await tester.tap(find.byKey(Key("loginscreen_scaffold")));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(1), "123456");
    await tester.tap(find.byKey(Key("loginscreen_scaffold")));
    await tester.pumpAndSettle();

    // Tap the login button
    final registerButtonFinder = find.byKey(
      const Key("loginscreen_loginbutton"),
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

    // Check if the navigation happened
    expect(find.byType(NavigationWrapper), findsOneWidget);

    await tester.tap(find.byKey(Key("mainbottomnavigation_profile")));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("profilescreen_leavetext")));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("dialogwidget_confirmbutton")));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Create account successful', (WidgetTester tester) async {
    await dotenv.load();
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    expect(find.text('Bem Vindo(a)!'), findsOneWidget);

    final createAccountButtonFinder = find.byKey(
      const Key("loginscreen_createaccountbutton"),
    );
    await tester.dragUntilVisible(
      createAccountButtonFinder,
      find.byType(ListView),
      const Offset(0, -1000),
      duration: Duration(seconds: 2),
    );
    await tester.pumpAndSettle();
    await tester.tap(createAccountButtonFinder);
    await tester.pumpAndSettle();

    expect(find.byType(LoginData), findsOneWidget);

    await tester.enterText(
        find.byType(TextFormField).at(0), faker.internet.email());
    await tester.enterText(find.byType(TextFormField).at(1), "123456");
    await tester.enterText(find.byType(TextFormField).at(2), "123456");

    await tester.tap(find.byKey(Key("logindatascreen_scaffold")));
    await tester.pumpAndSettle();

    final continueButtonFinder = find.byKey(
      const Key("logindatascreen_continuebutton"),
    );
    await tester.dragUntilVisible(
      continueButtonFinder,
      find.byType(ListView),
      const Offset(0, -1000),
      duration: Duration(seconds: 2),
    );
    await tester.pumpAndSettle();
    await tester.tap(continueButtonFinder);
    await tester.pumpAndSettle();

    expect(find.byType(PersonalData), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), "Jose Silva");
    await tester.tap(find.byKey(Key("personaldatascreen_scaffold")));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(1), "18/07/2005");
    await tester.tap(find.byKey(Key("personaldatascreen_scaffold")));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(TextFormField).at(2), "(86) 9 9471-7931");
    await tester.tap(find.byKey(Key("personaldatascreen_scaffold")));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(3), "Centro");
    await tester.tap(find.byKey(Key("personaldatascreen_scaffold")));
    await tester.pumpAndSettle();

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
