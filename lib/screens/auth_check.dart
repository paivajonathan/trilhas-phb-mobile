import "package:flutter/material.dart";
import "package:trilhas_phb/screens/authenticate/authenticate.dart";
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
          return const CircularProgressIndicator();
        }

        if (snapshot.data != null) {
          print(snapshot.data!["user_type"]);
          return const MainScreen();
        }

        return const AuthenticateScreen();
      }
    );
  }
}
