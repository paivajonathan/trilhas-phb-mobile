import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:trilhas_phb/constants/user_type.dart";
import "package:trilhas_phb/providers/user_data.dart";
import "package:trilhas_phb/screens/hiker/chat.dart" as hiker;
import "package:trilhas_phb/screens/hiker/explore/explore.dart" as hiker;
import "package:trilhas_phb/screens/hiker/profile.dart" as hiker;
import "package:trilhas_phb/screens/hiker/ranking.dart" as hiker;
import "package:trilhas_phb/screens/administrator/chat.dart" as administrator;
import "package:trilhas_phb/screens/administrator/explore/explore.dart"
    as administrator;
import "package:trilhas_phb/screens/administrator/profile.dart"
    as administrator;
import "package:trilhas_phb/screens/administrator/user_listing_screen.dart"
    as administrator;
import "package:trilhas_phb/widgets/main_bottom_navigation.dart";

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  int _selectedIndex = 0;
  late List<Widget> _screens;
  late String _userType;

  final _roleScreens = {
    UserType.administrator: [
      const administrator.ExploreScreen(),
      const administrator.ChatScreen(),
      const administrator.UserListingScreen(),
      const administrator.ProfileScreen(),
    ],
    UserType.hiker: [
      const hiker.ExploreScreen(),
      const hiker.ChatScreen(),
      const hiker.RankingScreen(),
      const hiker.ProfileScreen()
    ]
  };

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    final userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
    _userType = userDataProvider.userData!.userType;
    _screens = _roleScreens[_userType]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: MainBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _updateIndex,
        isAdmin: _userType == UserType.administrator,
      ),
    );
  }
}
