import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:trilhas_phb/models/user_data.dart';
import 'package:trilhas_phb/screens/authentication/login.dart';
import 'package:provider/provider.dart';
import 'package:trilhas_phb/providers/user_data.dart';
import 'package:trilhas_phb/screens/navigation_wrapper.dart';
import 'package:trilhas_phb/services/auth.dart';
import 'package:mockito/mockito.dart';

import 'check_user_info_screen_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthService>()])
void main() {
  late MockAuthService mockAuthService;

  setUpAll(() async {
    await dotenv.load(); // Load only once before all tests
    mockAuthService = MockAuthService();
    AuthService.setMockInstance(mockAuthService);

    final userProfileModel = UserProfileModel(
      userId: 1,
      userType: "A",
      userEmail: "admin@gmail.com",
      userIsAccepted: true,
      userIsActive: true,
      profileId: 1,
      profileBirthDate: DateTime(2005, 07, 18),
      profileCellphone: "86994717931",
      profileFullName: "Admin da Silva",
      profileNeighborhoodName: "Centro",
      profileStars: 0,
      profileIsActive: true,
    );
    when(mockAuthService.login(email: "admin@gmail.com", password: "123456"))
        .thenAnswer((_) async => userProfileModel);
  });

  testWidgets('LoginScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserDataProvider>(
            create: (context) => UserDataProvider(),
          ),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Verify if certain widgets are present on the screen
    expect(
        find.byType(TextFormField), findsNWidgets(2)); // For email and password
    expect(find.text('Bem Vindo(a)!'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Email field validation shows error on empty input',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserDataProvider>(
            create: (context) => UserDataProvider(),
          ),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Ensure the "Login" button is visible by scrolling the screen if necessary
    final loginButtonFinder = find.byKey(Key("loginscreen_loginbutton"));

    await tester.ensureVisible(loginButtonFinder);

    await tester.pumpAndSettle();

    await tester.tap(loginButtonFinder);

    await tester.pumpAndSettle();

    // Check if validation error is shown for email
    expect(find.text('Digite um email.'), findsOneWidget);
  });

  testWidgets('Login button triggers login method when form is valid',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserDataProvider>(
            create: (context) => UserDataProvider(),
          ),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Fill the form with valid input
    await tester.enterText(find.byType(TextFormField).at(0), "admin@gmail.com");
    await tester.enterText(find.byType(TextFormField).at(1), "123456");

    // Tap the login button
    final loginButtonFinder = find.byKey(Key("loginscreen_loginbutton"));
    await tester.ensureVisible(loginButtonFinder);
    await tester.pumpAndSettle();
    await tester.tap(loginButtonFinder);
    await tester.pumpAndSettle();

    // Check if the navigation happened
    expect(find.byType(NavigationWrapper), findsOneWidget);
  });
}
