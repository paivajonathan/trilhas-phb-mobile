import 'package:flutter/material.dart';
import 'package:trilhas_phb/screens/authentication/registration/login_data.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> sharedData = {
      "email": null,
      "password": null,
      "confirmPassword": null,

      "fullName": null,
      "birthDate": null,
      "phone": null,
      "neighborhoodName": null,
    };

    return LoginData(sharedData: sharedData);
  }
}