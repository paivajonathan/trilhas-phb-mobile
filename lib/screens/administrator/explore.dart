import "package:flutter/material.dart";
import "package:trilhas_phb/screens/administrator/explore_appointments.dart";
import "package:trilhas_phb/screens/administrator/explore_hikes.dart";
import "package:trilhas_phb/widgets/tab_navigation.dart";

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _tabsTitles = [
    "AGENDADAS",
    "CADASTRADAS",
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabsTitles.length,
      child: Scaffold(
        appBar: TabNavigation(tabsTitles: _tabsTitles),
        body: const TabBarView(
          children: [
            ExploreAppointmentsScreen(),
            ExploreHikesScreen(),
          ]
        )
      )
    );
  }
}
