import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';

class TabNavigationItem extends StatelessWidget {
  const TabNavigationItem({
    super.key,
    required String title,
    required int index,
    required TabController tabController,
  }) : _tabController = tabController, _index = index, _title = title;

  final String _title;
  final TabController _tabController;
  final int _index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _tabController.index == _index
          ? AppColors.primary
          : const Color(0xFFEAF2FF),
      ),
      child: Text(
        _title,
        style: TextStyle(
          color: _tabController.index == _index
            ? const Color(0xFFEAF2FF)
            : AppColors.primary
        ),
      ),
    );
  }
}
