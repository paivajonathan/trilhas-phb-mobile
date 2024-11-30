import 'package:flutter/material.dart';
import 'package:trilhas_phb/models/appointment.dart';
import 'package:trilhas_phb/screens/hiker/appointment_details.dart';
import 'package:trilhas_phb/services/appointment.dart';
import 'package:trilhas_phb/widgets/decorated_card.dart';
import 'package:trilhas_phb/widgets/loader.dart';

class ExploreAvailableScreen extends StatefulWidget {
  const ExploreAvailableScreen({super.key});

  @override
  State<ExploreAvailableScreen> createState() => _ExploreAllScreenState();
}

class _ExploreAllScreenState extends State<ExploreAvailableScreen> {
  final _appointmentService = AppointmentService();

  List<AppointmentModel> _availableAppointments = [];
  bool _isAvailableAppointmentsLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _loadAvailableAppointments();
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

  @override
  Widget build(BuildContext context) {
    if (_isAvailableAppointmentsLoading) {
      return const Loader();
    }

    if (_availableAppointments.isEmpty) {
      return const Center(child: Text("Os agendamentos aparecerão aqui."));
    }

    return ListView.separated(
      scrollDirection: Axis.vertical,
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
}
