import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:provider/provider.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import "package:trilhas_phb/providers/user_data.dart";
import "package:trilhas_phb/screens/auth_check.dart";

final themeData = ThemeData(
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.primary,
    selectionHandleColor: AppColors.primary,
  ),
);

Future<void> main() async {
  await dotenv.load();
  
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDataProvider>(create: (context) => UserDataProvider()),
      ],
      child: MaterialApp(
        title: "Trilhas PHB",
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: const AuthCheckScreen(),
      ),
    );
  }
}
