import 'package:flutter/material.dart';
import 'package:trilhas_phb/services/auth.dart';

class ProfileScreen extends StatelessWidget {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: GestureDetector(
              child: Text(
                'Sair',
                textAlign: TextAlign.center,
              ),
              onTap: () async {
                await _auth.signOut();
              },
            ),
          )
        ],
      ),
    );
  }
}
