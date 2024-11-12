import "package:flutter/material.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:trilhas_phb/screens/auth_check.dart";
import "package:trilhas_phb/services/hike.dart";

Future<void> main() async {
  await dotenv.load();
  final result = await HikeService().get();
  for (final i in result) {
    print(i.name);
  }
  runApp(const MainApp());
}

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
