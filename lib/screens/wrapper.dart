import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trilhas_phb/models/user.dart';
import 'package:trilhas_phb/screens/authenticate/authenticate.dart';
import 'package:trilhas_phb/screens/main.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    
    if (user == null)
      return Authenticate();

    return MainScreen();
  }
}