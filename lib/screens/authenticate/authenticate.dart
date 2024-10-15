import "package:flutter/material.dart";
import "package:trilhas_phb/screens/authenticate/register.dart";
import "package:trilhas_phb/screens/authenticate/login.dart";

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({super.key});

  @override
  State<AuthenticateScreen> createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  bool showLogin = true;

  void toggleView() {
    setState(() => showLogin = !showLogin);
  }

  @override
  Widget build(BuildContext context) {
    return showLogin 
      ? LoginScreen(toggleView: toggleView)
      : RegisterScreen(toggleView: toggleView);
  }
}