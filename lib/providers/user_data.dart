import 'package:flutter/material.dart';
import 'package:trilhas_phb/models/user_data.dart';

class UserDataProvider extends ChangeNotifier {
  UserDataModel? _userData;

  void setUserData(UserDataModel? userData) {
    _userData = userData;
    notifyListeners();
  }

  void clearUserData() {
    _userData = null;
    notifyListeners();
  }

  UserDataModel? get userData {
    return _userData;
  }
}