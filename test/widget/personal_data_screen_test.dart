// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:trilhas_phb/models/user_data.dart';
// import 'package:trilhas_phb/screens/authentication/login.dart';
// import 'package:provider/provider.dart';
// import 'package:trilhas_phb/providers/user_data.dart';
// import 'package:trilhas_phb/screens/authentication/registration/personal_data.dart';
// import 'package:trilhas_phb/screens/navigation_wrapper.dart';
// import 'package:trilhas_phb/services/auth.dart';
// import 'package:mockito/mockito.dart';

// import 'login_screen_test.mocks.dart';

// @GenerateNiceMocks([MockSpec<AuthService>()])
// void main() {
//   late MockAuthService mockAuthService;
//   late UserProfileModel userProfileModel;
//   late Map<String, dynamic> sharedData;

//   setUpAll(() async {
//     await dotenv.load();

//     mockAuthService = MockAuthService();
//     AuthService.setMockInstance(mockAuthService);

//     sharedData = {
//       "email": "afadsfsda",
//       "password": "fasdfasdf",
//       "confirmPassword": "fddfasfads",
//       "fullName": null,
//       "birthDate": null,
//       "phone": null,
//       "neighborhoodName": null,
//     };
//     userProfileModel = UserProfileModel(
//       userId: 1,
//       userType: "H",
//       userEmail: "jose@gmail.com",
//       userIsAccepted: true,
//       userIsActive: true,
//       profileId: 1,
//       profileBirthDate: DateTime(2005, 07, 18),
//       profileCellphone: "86994717931",
//       profileFullName: "Jose da Silva",
//       profileNeighborhoodName: "Centro",
//       profileStars: 0,
//       profileIsActive: true,
//     );
//   });

//   testWidgets('PersonalDataScreen renders correctly',
//       (WidgetTester tester) async {
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<UserDataProvider>(
//             create: (context) => UserDataProvider(),
//           ),
//         ],
//         child: MaterialApp(
//           home: PersonalData(sharedData: sharedData),
//         ),
//       ),
//     );

//     final continueButtonFinder = find.byKey(const Key("teste"));


//     await tester.dragUntilVisible(
//         continueButtonFinder, // what you want to find
//         find.byType(ListView),
//         // widget you want to scroll
//         const Offset(0, 1000), // delta to move
//         duration: Duration(seconds: 2));

//     // print(continueButtonFinder.evaluate().toString());
//     await tester.pumpAndSettle();
//     await tester.ensureVisible(continueButtonFinder);
//     await tester.pumpAndSettle();
//     await tester.tap(continueButtonFinder);
//     await tester.pumpAndSettle();

//     expect(1, 1);
//   });

//   // testWidgets('Field validation shows error on empty input',
//   //     (WidgetTester tester) async {
//   //   await tester.pumpWidget(
//   //     MultiProvider(
//   //       providers: [
//   //         ChangeNotifierProvider<UserDataProvider>(
//   //           create: (context) => UserDataProvider(),
//   //         ),
//   //       ],
//   //       child: MaterialApp(
//   //         home: PersonalData(
//   //           sharedData: sharedData,
//   //         ),
//   //       ),
//   //     ),
//   //   );

//   //   final continueButtonFinder =
//   //       find.byKey(const Key("personaldatascreen_registerbutton"));
//   //   await tester.ensureVisible(continueButtonFinder);
//   //   await tester.pumpAndSettle();
//   //   await tester.tap(continueButtonFinder);
//   //   await tester.pumpAndSettle();
//   //   // await tester.tap(registerButtonFinder);
//   //   // await tester.pumpAndSettle();

//   //   expect(1, 1);
//   //   // expect(find.text('Digite seu nome completo.'), findsOneWidget);
//   //   // expect(find.text('Digite sua data de aniversário.'), findsOneWidget);
//   //   // expect(find.text('Digite seu número de celular.'), findsOneWidget);
//   // });

//   // testWidgets('Login button triggers login method when form is valid',
//   //     (WidgetTester tester) async {
//   //   when(mockAuthService.login(email: "admin@gmail.com", password: "123456"))
//   //       .thenAnswer((_) async => userProfileModel);

//   //   await tester.pumpWidget(
//   //     MultiProvider(
//   //       providers: [
//   //         ChangeNotifierProvider<UserDataProvider>(
//   //           create: (context) => UserDataProvider(),
//   //         ),
//   //       ],
//   //       child: const MaterialApp(
//   //         home: LoginScreen(),
//   //       ),
//   //     ),
//   //   );

//   //   // Fill the form with valid input
//   //   await tester.enterText(find.byType(TextFormField).at(0), "admin@gmail.com");
//   //   await tester.enterText(find.byType(TextFormField).at(1), "123456");

//   //   // Tap the login button
//   //   final loginButtonFinder = find.byKey(const Key("loginscreen_loginbutton"));
//   //   await tester.ensureVisible(loginButtonFinder);
//   //   await tester.pumpAndSettle();
//   //   await tester.tap(loginButtonFinder);
//   //   await tester.pumpAndSettle();

//   //   // Check if the navigation happened
//   //   expect(find.byType(NavigationWrapper), findsOneWidget);
//   // });
// }
