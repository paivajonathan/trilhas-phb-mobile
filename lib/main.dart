import "package:flutter/material.dart";
import "package:trilhas_phb/screens/auth_check.dart";

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Trilhas PHB",
      home: AuthCheckScreen(),
    );
  }
}
