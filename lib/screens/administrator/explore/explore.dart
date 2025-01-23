import "package:flutter/material.dart";
import "package:trilhas_phb/models/appointment.dart";
import "package:trilhas_phb/models/hike.dart";
import "package:trilhas_phb/screens/administrator/explore/explore_appointments.dart";
import "package:trilhas_phb/screens/administrator/explore/explore_finished_appointments.dart";
import "package:trilhas_phb/screens/administrator/explore/explore_hikes.dart";
import "package:trilhas_phb/services/appointment.dart";
import "package:trilhas_phb/services/hike.dart";
import "package:trilhas_phb/widgets/tab_navigation.dart";

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _appointmentService = AppointmentService();
  final _hikeService = HikeService();

  List<AppointmentModel> _finishedAppointments = [];
  bool _isFinishedAppointmentsLoading = false;
  String? _isFinishedAppointmentsLoadingError;

  List<AppointmentModel> _appointments = [];
  bool _isAppointmentsLoading = false;
  String? _isAppointmentsLoadingError;

  List<HikeModel> _hikes = [];
  bool _isHikesLoading = false;
  String? _isHikesLoadingError;

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  void _loadData() {
    Future.wait([
      _loadFinishedAppointments(),
      _loadAppointments(),
      _loadHikes(),
    ]);
  }

  Future<void> _loadFinishedAppointments() async {
    try {
      setState(() {
        _isFinishedAppointmentsLoading = true;
      });

      final finishedAppointments = await _appointmentService.getAll(
        isActive: true,
        isAvailable: false,
      );

      setState(() {
        _finishedAppointments = finishedAppointments;
        _isFinishedAppointmentsLoadingError = null;
      });
    } catch (e) {
      setState(() {
        _finishedAppointments = [];
        _isFinishedAppointmentsLoadingError =
            e.toString().replaceAll("Exception: ", "");
      });
    } finally {
      setState(() {
        _isFinishedAppointmentsLoading = false;
      });
    }
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
        _appointments = appointments;
        _isAppointmentsLoadingError = null;
      });
    } catch (e) {
      setState(() {
        _appointments = [];
        _isAppointmentsLoadingError =
            e.toString().replaceAll("Exception: ", "");
      });
    } finally {
      setState(() {
        _isAppointmentsLoading = false;
      });
    }
  }

  Future<void> _loadHikes() async {
    try {
      setState(() {
        _isHikesLoading = true;
      });

      final hikes = await _hikeService.getAll(isActive: true);

      setState(() {
        _hikes = hikes;
        _isHikesLoadingError = null;
      });
    } catch (e) {
      setState(() {
        _hikes = [];
        _isHikesLoadingError = e.toString().replaceAll("Exception: ", "");
      });
    } finally {
      setState(() {
        _isHikesLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  final _tabsTitles = [
    "CONCLUÍDAS",
    "AGENDADAS",
    "CADASTRADAS",
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
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ExploreFinishedAppointmentsScreen(
              finishedAppointments: _finishedAppointments,
              isFinishedAppointmentsLoading: _isFinishedAppointmentsLoading,
              isFinishedAppointmentsLoadingError:
                  _isFinishedAppointmentsLoadingError,
              onUpdate: _loadData,
            ),
            ExploreAppointmentsScreen(
              appointments: _appointments,
              isAppointmentsLoading: _isAppointmentsLoading,
              isAppointmentsLoadingError: _isAppointmentsLoadingError,
              onUpdate: _loadData,
            ),
            ExploreHikesScreen(
              hikes: _hikes,
              isHikesLoading: _isHikesLoading,
              isHikesLoadingError: _isHikesLoadingError,
              onUpdate: _loadData,
            ),
          ],
        ),
      ),
    );
  }
}
