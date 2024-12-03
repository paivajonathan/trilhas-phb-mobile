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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.primary),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(tabTitle),
        ),
      ),
    );
  }
}
