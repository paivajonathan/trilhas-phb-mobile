import "package:flutter/material.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import "package:trilhas_phb/models/appointment.dart";
import "package:trilhas_phb/screens/hiker/appointment_details.dart";
import "package:trilhas_phb/services/appointment.dart";
import "package:trilhas_phb/widgets/decorated_card.dart";
import "package:trilhas_phb/widgets/decorated_list_tile.dart";
import "package:trilhas_phb/widgets/tab_navigation.dart";

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
  final _tabsTitles = ["TODAS", "INSCRIÇÕES", "PARTICIPAR"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabsTitles.length, vsync: this);
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
      appBar: TabNavigation(
        tabController: _tabController,
        tabsTitles: _tabsTitles,
        onTap: (index) {
          setState(() {
            _tabController.index = index;
          });
        },
      ),
      body: _isAppointmentsLoading
        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
        : currentView
    );
  }
}
