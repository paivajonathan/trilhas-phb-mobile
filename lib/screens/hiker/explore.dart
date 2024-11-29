import "package:flutter/material.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import "package:trilhas_phb/models/appointment.dart";
import "package:trilhas_phb/screens/hiker/appointment_details.dart";
import "package:trilhas_phb/services/appointment.dart";
import "package:trilhas_phb/widgets/decorated_card.dart";
import "package:trilhas_phb/widgets/decorated_list_tile.dart";

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> with SingleTickerProviderStateMixin {
  final _appointmentService = AppointmentService();

  List<AppointmentModel> _availableAppointments = [];
  List<AppointmentModel> _userAppointments = [];
  bool _isAppointmentsLoading = false;

  late TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _loadAppointments();
    });
  }

  Future<void> _loadAppointments() async {
    try {
      setState(() {
        _isAppointmentsLoading = true;
      });

      final appointments = await _appointmentService.getAll(
        isActive: true,
        isAvailable: true,
      );

      setState(() {
        _isAppointmentsLoading = false;
        _availableAppointments = appointments.where((a) => !a.hasUserParticipation).toList();
        _userAppointments = appointments.where((a) => a.hasUserParticipation).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    } finally {
      setState(() {
        _isAppointmentsLoading = false;
      });
    }
  }

  AppBar _getAppBar() {
    return AppBar(
        toolbarHeight: 25,
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) => setState(() => _tabIndex = index),
          indicatorColor: Colors.transparent,
          dividerColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) => states.contains(WidgetState.focused)
              ? null
              : Colors.transparent
          ),
          tabs: [
            Tab(
              tabController: _tabController,
              index: 0,
              title: "TODAS",
            ),
            Tab(
              tabController: _tabController,
              index: 1,
              title: "PARTICIPAR",
            ),
            Tab(
              tabController: _tabController,
              index: 2,
              title: "INSCRIÇÕES",
            ),
          ],
        ),
      );
  }

  Widget _getOnlyUserAppointments() {
    return _userAppointments.isEmpty
      ? const Center(child: Text("Suas trilhas aparecerão aqui."))
      : ListView.separated(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          separatorBuilder: (context, value) => const SizedBox(width: 20),
          itemCount: _userAppointments.length,
          itemBuilder: (context, index) {
            final appointment = _userAppointments[index];
            return DecoratedListTile(appointment: appointment);
          },
        );
  }

  Widget _getOnlyAvailableAppointments() {
    return _availableAppointments.isEmpty
      ? const Center(child: Text("Os agendamentos aparecerão aqui."))
      : ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          separatorBuilder: (context, value) => const SizedBox(width: 20),
          itemCount: _availableAppointments.length,
          itemBuilder: (context, index) {
            final appointment = _availableAppointments[index];
            return DecoratedCard(
              appointment: appointment,
              actionText: "Participar",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AppointmentDetailsScreen(
                        appointment: appointment),
                  ),
                );
              },
            );
          },
        );
  }

  Widget _getAllAppointmentsView() {
    return Column(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
          alignment: Alignment.center,
          child: _availableAppointments.isEmpty
            ? const Center(child: Text("Os agendamentos aparecerão aqui."))
            : ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                separatorBuilder: (context, value) => const SizedBox(width: 20),
                itemCount: _availableAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = _availableAppointments[index];
                  return DecoratedCard(
                    appointment: appointment,
                    actionText: "Participar",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AppointmentDetailsScreen(
                              appointment: appointment),
                        ),
                      );
                    },
                  );
                },
              ),
        ),
        Expanded(
          child: _userAppointments.isEmpty
            ? const Center(child: Text("Suas trilhas aparecerão aqui."))
            : ListView.separated(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                separatorBuilder: (context, value) => const SizedBox(width: 20),
                itemCount: _userAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = _userAppointments[index];
                  return DecoratedListTile(appointment: appointment);
                },
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentView = switch(_tabController.index) {
      0 => _getAllAppointmentsView(),
      1 => _getOnlyAvailableAppointments(),
      _ => _getOnlyUserAppointments(),
    };

    return Scaffold(
      appBar: _getAppBar(),
      body: _isAppointmentsLoading
        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
        : currentView
    );
  }
}

class Tab extends StatelessWidget {
  const Tab({
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
