import 'package:flutter/material.dart';
import 'package:trilhas_phb/models/appointment.dart';
import 'package:trilhas_phb/screens/hiker/appointment_details.dart';
import 'package:trilhas_phb/services/appointment.dart';
import 'package:trilhas_phb/widgets/decorated_card.dart';
import 'package:trilhas_phb/widgets/decorated_list_tile.dart';
import 'package:trilhas_phb/widgets/loader.dart';

class ExploreAllScreen extends StatefulWidget {
  const ExploreAllScreen({super.key});

  @override
  State<ExploreAllScreen> createState() => _ExploreAllScreenState();
}

class _ExploreAllScreenState extends State<ExploreAllScreen> {
  final _appointmentService = AppointmentService();

  List<AppointmentModel> _availableAppointments = [];
  bool _isAvailableAppointmentsLoading = false;
  
  List<AppointmentModel> _userAppointments = [];
  bool _isUserAppointmentsLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _loadAvailableAppointments();
      _loadUserAppointments();
    });
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
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
        _isAvailableAppointmentsLoading = false;
        _availableAppointments = appointments;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    } finally {
      setState(() {
        _isAvailableAppointmentsLoading = false;
      });
    }
  }

  Future<void> _loadUserAppointments() async {
    try {
      if (!mounted) return;

      setState(() {
        _isUserAppointmentsLoading = true;
      });

      final appointments = await _appointmentService.getAll(
        isActive: true,
        isAvailable: true,
        hasUserParticipation: true,
      );

      setState(() {
        _isUserAppointmentsLoading = false;
        _userAppointments = appointments;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    } finally {
      setState(() {
        _isUserAppointmentsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 300,
          alignment: Alignment.center,
          child: _isAvailableAppointmentsLoading
            ? const Loader()
            : _availableAppointments.isEmpty
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
          child: _isUserAppointmentsLoading
            ? const Loader()
            : _userAppointments.isEmpty
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
}
