import "package:flutter/material.dart";
import "package:trilhas_phb/screens/authentication/login.dart";
import "package:trilhas_phb/services/auth.dart";

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({ super.key });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Perfil",
            style: TextStyle(fontSize: 35),
          ),
          GestureDetector(
            child: const Text(
              "Sair",
              style: TextStyle(fontSize: 25),
            ),
            onTap: () async {
              await _auth.logout();
              
              if (!context.mounted) return;
              
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          )
        ],
      ),
    );
  }
}
