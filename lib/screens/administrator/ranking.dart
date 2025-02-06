import 'package:flutter/material.dart';
import 'package:trilhas_phb/screens/administrator/user_listing_screen.dart'; // ajuste o caminho conforme necessário

class RankingScreen extends StatelessWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListaUsuariosScreen(),
    );
  }
}