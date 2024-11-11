import 'package:flutter/material.dart';
import 'package:trilhas_phb/screens/authenticate/login_data.dart';

class RegisterProvider extends ChangeNotifier {
  String? _email;
  String? _password;
  String? _confirmPassword;

  String? _fullName;
  String? _birthDate;
  String? _phoneNumber;
  String? _neighborhoodName;

  String? get email => _email;
  set email(String? value) {
    _email = value;
    notifyListeners();
  }

  String? get password => _password;
  set password(String? value) {
    _password = value;
    notifyListeners();
  }

  String? get confirmPassword => _confirmPassword;
  set confirmPassword(String? value) {
    _confirmPassword = value;
    notifyListeners();
  }

  String? get fullName => _fullName;
  set fullName(String? value) {
    _fullName = value;
    notifyListeners();
  }

  String? get birthDate => _birthDate;
  set birthDate(String? value) {
    _birthDate = value;
    notifyListeners();
  }

  String? get phoneNumber => _phoneNumber;
  set phoneNumber(String? value) {
    _phoneNumber = value;
    notifyListeners();
  }

  String? get neighborhoodName => _neighborhoodName;
  set neighborhoodName(String? value) {
    _neighborhoodName = value;
    notifyListeners();
  }
}

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