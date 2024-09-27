import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trilhas_phb/models/user.dart';
import 'package:trilhas_phb/screens/wrapper.dart';
import 'package:trilhas_phb/services/auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      initialData: null,
      value: _auth.user,
      child: const MaterialApp(
        title: 'Trilhas PHB',
        home: Wrapper(),
      ),
    );
  }
}
