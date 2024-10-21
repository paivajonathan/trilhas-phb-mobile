import "package:flutter/material.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import "package:trilhas_phb/screens/authenticate/login.dart";
import "package:trilhas_phb/screens/main.dart";
import "package:trilhas_phb/services/auth.dart";

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  final authService = AuthService();

  late Future<Map<String, dynamic>?> _user;

  @override
  void initState() {
    super.initState();
    _user = authService.user;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary)
          );
        }

        if (snapshot.data != null) {
          return MainScreen(userData: snapshot.data!);
        }

        return const LoginScreen();
      }
    );
  }
}
