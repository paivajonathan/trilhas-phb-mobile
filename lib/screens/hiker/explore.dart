import "package:flutter/material.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import "package:trilhas_phb/models/appointment.dart";
import "package:trilhas_phb/services/appointment.dart";
import "package:trilhas_phb/widgets/decorated_card.dart";

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _appointmentService = AppointmentService();
  final _appointments = <AppointmentModel>[];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    try {
      if (_isLoading) return;

      setState(() => _isLoading = true);

      final appointments = await _appointmentService.getAll(isPresent: false);

      setState(() {
        _isLoading = false;
        _appointments.insertAll(0, appointments);
      } );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    } finally {
      // TODO: Verificar porque não tá chegando aqui
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 50),
            SizedBox(
              height: 250,
              child: _appointments.isEmpty
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    separatorBuilder: (context, value) {
                      return const SizedBox(width: 20);
                    },
                    itemCount: _appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = _appointments[index];
                      return DecoratedCard(appointment: appointment, actionText: "Participar");
                    },
                  ),
            ),
          ],
        ),
      );
  }
}
