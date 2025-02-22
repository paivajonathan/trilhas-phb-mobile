import 'package:flutter/material.dart';
import 'package:trilhas_phb/models/user_data.dart';

class UserDataProvider extends ChangeNotifier {
  UserProfileModel? _userData;

  void setUserData(UserProfileModel? userData) {
    _userData = userData;
    notifyListeners();
  }

  void clearUserData() {
    _userData = null;
    notifyListeners();
  }

  UserProfileModel? get userData {
    return _userData;
  }
}