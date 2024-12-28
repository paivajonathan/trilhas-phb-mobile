import "package:flutter/material.dart";
import "package:trilhas_phb/screens/hiker/explore/explore_all.dart";
import "package:trilhas_phb/screens/hiker/explore/explore_available.dart";
import "package:trilhas_phb/screens/hiker/explore/explore_user.dart";
import "package:trilhas_phb/widgets/tab_navigation.dart";

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _tabsTitles = [
    "TODAS",
    "PARTICIPAR",
    "INSCRIÇÕES",
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabsTitles.length,
      child: Scaffold(
        appBar: TabNavigation(tabsTitles: _tabsTitles),
        body: const TabBarView(
          children: [
            ExploreAllScreen(),
            ExploreAvailableScreen(),
            ExploreUserScreen(),
          ]
        )
      )
    );
  }
}
