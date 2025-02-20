import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trilhas_phb/main.dart';
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
    await tester.enterText(find.byType(TextFormField).at(1), "123456");

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
  });
}
