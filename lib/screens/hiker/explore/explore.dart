import "package:flutter/material.dart";
import "package:trilhas_phb/models/appointment.dart";
import "package:trilhas_phb/screens/hiker/explore/explore_all.dart";
import "package:trilhas_phb/screens/hiker/explore/explore_available.dart";
import "package:trilhas_phb/screens/hiker/explore/explore_user.dart";
import "package:trilhas_phb/services/appointment.dart";
import "package:trilhas_phb/widgets/tab_navigation.dart";

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _appointmentService = AppointmentService();

  List<AppointmentModel> _availableAppointments = [];
  bool _isAvailableAppointmentsLoading = false;
  String? _isAvailableAppointmentsLoadingError;

  List<AppointmentModel> _userAppointments = [];
  bool _isUserAppointmentsLoading = false;
  String? _isUserAppointmentsLoadingError;

  void _loadData() {
    Future.wait([_loadAvailableAppointments(), _loadUserAppointments()]);
  }

  Future<void> _loadAvailableAppointments() async {
    try {
      setState(() {
        _isAvailableAppointmentsLoading = true;
      });

      final appointments = await _appointmentService.getAll(
        isActive: true,
        isAvailable: true,
        hasUserParticipation: false,
      );

      setState(() {
        _availableAppointments = appointments;
        _isAvailableAppointmentsLoadingError = null;
      });
    } catch (e) {
      setState(() {
        _availableAppointments = [];
        _isAvailableAppointmentsLoadingError =
            e.toString().replaceAll("Exception: ", "");
      });
    } finally {
      setState(() {
        _isAvailableAppointmentsLoading = false;
      });
    }
  }

  Future<void> _loadUserAppointments() async {
    try {
      setState(() {
        _isUserAppointmentsLoading = true;
      });

      final appointments = await _appointmentService.getAll(
        isActive: true,
        isAvailable: true,
        hasUserParticipation: true,
      );

      setState(() {
        _userAppointments = appointments;
        _isUserAppointmentsLoadingError = null;
      });
    } catch (e) {
      setState(() {
        _userAppointments = [];
        _isUserAppointmentsLoadingError =
            e.toString().replaceAll("Exception: ", "");
      });
    } finally {
      setState(() {
        _isUserAppointmentsLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  final _tabsTitles = [
    "TODAS",
    "PARTICIPAR",
    "INSCRIÇÕES",
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabsTitles.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: TabNavigation(tabsTitles: _tabsTitles),
        body: TabBarView(
          children: [
            ExploreAllScreen(
              availableAppointments: _availableAppointments,
              isAvailableAppointmentsLoading: _isAvailableAppointmentsLoading,
              isAvailableAppointmentsLoadingError:
                  _isAvailableAppointmentsLoadingError,
              userAppointments: _userAppointments,
              isUserAppointmentsLoading: _isUserAppointmentsLoading,
              isUserAppointmentsLoadingError: _isUserAppointmentsLoadingError,
              onUpdate: _loadData,
            ),
            ExploreAvailableScreen(
              availableAppointments: _availableAppointments,
              isAvailableAppointmentsLoading: _isAvailableAppointmentsLoading,
              isAvailableAppointmentsLoadingError:
                  _isAvailableAppointmentsLoadingError,
              onUpdate: _loadData,
            ),
            ExploreUserScreen(
              userAppointments: _userAppointments,
              isUserAppointmentsLoading: _isUserAppointmentsLoading,
              isUserAppointmentsLoadingError: _isUserAppointmentsLoadingError,
              onUpdate: _loadData,
            ),
          ],
        ),
      ),
    );
  }
}
