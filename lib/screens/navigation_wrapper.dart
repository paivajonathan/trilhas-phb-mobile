import "package:flutter/material.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import "package:trilhas_phb/constants/user_type.dart";
import "package:trilhas_phb/models/user.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:trilhas_phb/screens/hiker/chat.dart" as hiker;
import "package:trilhas_phb/screens/hiker/explore.dart" as hiker;
import "package:trilhas_phb/screens/hiker/profile.dart" as hiker;
import "package:trilhas_phb/screens/hiker/ranking.dart" as hiker;
import "package:trilhas_phb/screens/administrator/chat.dart" as administrator;
import "package:trilhas_phb/screens/administrator/explore.dart"
    as administrator;
import "package:trilhas_phb/screens/administrator/profile.dart"
    as administrator;
import "package:trilhas_phb/screens/administrator/ranking.dart"
    as administrator;

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key, required this.userData});

  final UserLoginModel userData;

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    final userId = widget.userData.id;
    final userType = widget.userData.type;

    if (userType == UserType.administrator) {
      _screens = [
        const administrator.ExploreScreen(),
        administrator.ChatScreen(userId: userId),
        const administrator.RankingScreen(),
        const administrator.ProfileScreen(),
      ];
    } else {
      _screens = [
        const hiker.ExploreScreen(),
        hiker.ChatScreen(userId: userId),
        const hiker.RankingScreen(),
        const hiker.ProfileScreen()
      ];
    }
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
