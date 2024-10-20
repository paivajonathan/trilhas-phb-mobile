import "package:flutter/material.dart";
import "package:trilhas_phb/screens/authenticate/login.dart";
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
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50),
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: GestureDetector(
              child: const Text(
                "Sair",
                textAlign: TextAlign.center,
              ),
              onTap: () async {
                await _auth.logout();
                print("Testando");
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
