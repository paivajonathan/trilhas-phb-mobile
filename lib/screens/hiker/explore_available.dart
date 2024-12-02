import 'package:flutter/material.dart';
import 'package:trilhas_phb/screens/hiker/appointment_details.dart';
import 'package:trilhas_phb/services/appointment.dart';
import 'package:trilhas_phb/widgets/decorated_card.dart';
import 'package:trilhas_phb/widgets/loader.dart';

class ExploreAvailableScreen extends StatefulWidget {
  const ExploreAvailableScreen({super.key});

  @override
  State<ExploreAvailableScreen> createState() => _ExploreAvailableScreenState();
}

class _ExploreAvailableScreenState extends State<ExploreAvailableScreen> {
  final _appointmentService = AppointmentService();

  @override
  Widget build(BuildContext context) {
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
          child: FutureBuilder(
            future: _appointmentService.getAll(
              isActive: true,
              isAvailable: true,
              hasUserParticipation: false,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text("Ocorreu um erro"),
                );
              }

              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("Os agendamentos aparecerão aqui."),
                );
              }

              return ListView.separated(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                separatorBuilder: (context, value) => const SizedBox(height: 10),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final appointment = snapshot.data![index];
                  return DecoratedCard(
                    appointment: appointment,
                    actionText: "Participar",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return AppointmentDetailsScreen(
                              appointment: appointment,
                            );
                          },
                        ),
                      ).then((value) => setState(() {}));
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
