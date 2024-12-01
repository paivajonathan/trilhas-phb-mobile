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
    if (mounted) {
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
    late Widget appointmentsView;

    if (_isAvailableAppointmentsLoading) {
      appointmentsView = const Loader();
    } else if (_availableAppointments.isEmpty) {
      appointmentsView = const Center(
        child: Text("Os agendamentos aparecerão aqui."),
      );
    } else {
      appointmentsView = ListView.separated(
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
                  builder: (context) =>
                      AppointmentDetailsScreen(appointment: appointment),
                ),
              );
            },
          );
        },
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: const Text(
            "Trilhas agendadas",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: appointmentsView,
        ),
      ],
    );
  }
}
