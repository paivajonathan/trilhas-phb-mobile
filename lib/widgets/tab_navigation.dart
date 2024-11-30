import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/widgets/tab_navigation_item.dart';

class TabNavigation extends StatefulWidget implements PreferredSizeWidget {
  const TabNavigation({
    super.key,
    required List<String> tabsTitles,
  }) : _tabsTitles = tabsTitles;

  final List<String> _tabsTitles;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<TabNavigation> createState() => _TabsNavigationState();
}

class _TabsNavigationState extends State<TabNavigation> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 10,
      bottom: TabBar(
        unselectedLabelColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.white,
        indicator: BoxDecoration(borderRadius: BorderRadius.circular(50), color: AppColors.primary),
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => states.contains(WidgetState.focused)
            ? null
            : Colors.transparent
        ),
        tabs: [
          for (final tabTitle in widget._tabsTitles)
            TabNavigationItem(tabTitle: tabTitle),
        ]
      )
    );
  }
}
