import 'package:flutter/material.dart';
import 'package:trilhas_phb/widgets/tab_navigation_item.dart';

class TabNavigation extends StatefulWidget implements PreferredSizeWidget {
  const TabNavigation({
    super.key,
    required TabController tabController,
    required List<String> tabsTitles,
    required void Function(int) onTap,
  }) : _tabController = tabController, _tabsTitles = tabsTitles, _onTap = onTap;

  final TabController _tabController;
  final List<String> _tabsTitles;
  final void Function(int) _onTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<TabNavigation> createState() => _TabsNavigationState();
}

class _TabsNavigationState extends State<TabNavigation> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 25,
      bottom: TabBar(
        onTap: widget._onTap,
        controller: widget._tabController,
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => states.contains(WidgetState.focused)
            ? null
            : Colors.transparent
        ),
        tabs: [
          for (var (index, value) in widget._tabsTitles.indexed)
            TabNavigationItem(tabController: widget._tabController, title: value, index: index)
        ],
      ),
    );
  }
}
