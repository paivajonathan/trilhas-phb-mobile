import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:trilhas_phb/models/user_data.dart";
import "package:trilhas_phb/providers/user_data.dart";
import "package:trilhas_phb/screens/authentication/login.dart";
import "package:trilhas_phb/screens/navigation_wrapper.dart";
import "package:trilhas_phb/services/auth.dart";
import "package:trilhas_phb/widgets/loader.dart";

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  final authService = AuthService();

  late UserDataModel? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    _userData = await authService.userData;

    if (!mounted) return;

    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    (_userData != null)
        ? userDataProvider.setUserData(_userData)
        : userDataProvider.clearUserData();

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Loader(),
      );
    }

    if (_userData != null) {
      return const NavigationWrapper();
    }

    return const LoginScreen();
  }
}
