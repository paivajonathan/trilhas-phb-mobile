import 'package:flutter/material.dart';
import 'package:trilhas_phb/screens/authenticate/authenticate.dart';
import 'package:trilhas_phb/services/auth.dart';

class ProfileScreen extends StatelessWidget {
  final _auth = AuthService();

  ProfileScreen({ super.key });

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
                'Sair',
                textAlign: TextAlign.center,
              ),
              onTap: () async {
                await _auth.logout();
                print("Testando");
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Authenticate()),
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
