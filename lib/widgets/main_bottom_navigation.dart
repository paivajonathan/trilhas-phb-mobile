import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trilhas_phb/constants/app_colors.dart';

class MainBottomNavigation extends StatelessWidget {
  const MainBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isAdmin,
  });

  final int currentIndex;
  final void Function(int)? onTap;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.secondary,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.solidCompass),
          label: "Explorar",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble),
          label: "Comunicados",
        ),
        if (isAdmin)
          const BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Usuários",
          ),
        if (!isAdmin)
          const BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: "Classificação",
          ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Perfil",
        ),
      ],
    );
  }
}
