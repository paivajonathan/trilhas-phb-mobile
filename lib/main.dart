import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import "package:trilhas_phb/screens/auth_check.dart";

Future<void> main() async {
  await dotenv.load();
  runApp(const MainApp());
}

final themeData = ThemeData(
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.primary,
    selectionHandleColor: AppColors.primary,
  ),
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Trilhas PHB",
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: const AuthCheckScreen(),
    );
  }
}
