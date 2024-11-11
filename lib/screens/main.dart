import "package:flutter/material.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import "package:trilhas_phb/models/user.dart";
import "package:trilhas_phb/screens/chat/chat.dart";
import "package:trilhas_phb/screens/home/home.dart";
import "package:trilhas_phb/screens/profile/profile.dart";
import "package:trilhas_phb/screens/ranking/ranking.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.userData});

  final UserLoginModel userData;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    
    final userId = widget.userData.id;
    final userType = widget.userData.type;

    _screens = [
      const HomeScreen(),
      ChatScreen(userId: userId),
      const RankingScreen(),
      const ProfileScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondary,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (int index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidCompass),
            label: "Explorar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: "Comunicados",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: "Classificação",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}
