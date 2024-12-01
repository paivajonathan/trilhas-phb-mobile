import 'package:flutter/material.dart';
import 'package:trilhas_phb/models/appointment.dart';
import 'package:trilhas_phb/screens/hiker/appointment_details.dart';
import 'package:trilhas_phb/services/appointment.dart';
import 'package:trilhas_phb/widgets/decorated_card.dart';
import 'package:trilhas_phb/widgets/loader.dart';

class ExploreUserScreen extends StatefulWidget {
  const ExploreUserScreen({super.key});

  @override
  State<ExploreUserScreen> createState() => _ExploreAllScreenState();
}

class _ExploreAllScreenState extends State<ExploreUserScreen> {
  final _appointmentService = AppointmentService();

  List<AppointmentModel> _userAppointments = [];
  bool _isUserAppointmentsLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _loadUserAppointments();
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
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
    late Widget appointmentsView;

    if (_isUserAppointmentsLoading) {
      appointmentsView = const Loader();
    } else if (_userAppointments.isEmpty) {
      appointmentsView = const Center(
        child: Text("Suas trilhas aparecerão aqui."),
      );
    } else {
      appointmentsView = ListView.separated(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        separatorBuilder: (context, value) => const SizedBox(width: 20),
        itemCount: _userAppointments.length,
        itemBuilder: (context, index) {
          final appointment = _userAppointments[index];
          return DecoratedCard(
            isPrimary: false,
            appointment: appointment,
            actionText: "Informações",
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
            "Suas trilhas",
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
