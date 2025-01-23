import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';

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
