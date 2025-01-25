import 'package:flutter/material.dart';

class TabNavigationItem extends StatelessWidget {
  const TabNavigationItem({
    super.key,
    required this.tabTitle,
  });

  final String tabTitle;

  @override
  Widget build(BuildContext context) {
    return Tab(
      text: tabTitle,
    );
  }
}
