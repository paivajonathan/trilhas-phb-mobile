import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';

class TabNavigation extends StatefulWidget implements PreferredSizeWidget {
  const TabNavigation({
    super.key,
    required this.tabsTitles,
  });

  final List<String> tabsTitles;

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
      backgroundColor: Colors.white,
      bottom: TabBar(        
        unselectedLabelColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        tabAlignment: TabAlignment.center,
        indicatorAnimation: TabIndicatorAnimation.elastic,
        isScrollable: true,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        labelColor: Colors.white,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: AppColors.primary),
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) => states.contains(WidgetState.focused)
                ? null
                : Colors.transparent),
        tabs: widget.tabsTitles
            .map((e) => Tab(child: Container(width: 100, alignment: Alignment.center, child: Text(e),),))
            .toList(),
      ),
    );
  }
}
