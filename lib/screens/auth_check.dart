import "package:flutter/material.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import "package:trilhas_phb/models/user.dart";
import "package:trilhas_phb/screens/authenticate/login.dart";
import "package:trilhas_phb/screens/navigation_wrapper.dart";
import "package:trilhas_phb/services/auth.dart";

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  final authService = AuthService();

  late UserLoginModel? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    _userData = await authService.userData;
    setState(() => _isLoading = false);
  }

  Widget _getLoadingScreen() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          value: 1,
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _getLoadingScreen();
    }

    if (_userData != null) {
      return NavigationWrapper(userData: _userData!);
    }
    
    return const LoginScreen();
  }
}
