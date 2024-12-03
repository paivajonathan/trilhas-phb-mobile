import 'package:flutter/material.dart';
import 'package:trilhas_phb/screens/hiker/appointment_details.dart';
import 'package:trilhas_phb/services/appointment.dart';
import 'package:trilhas_phb/widgets/decorated_card.dart';
import 'package:trilhas_phb/widgets/loader.dart';

class ExploreUserScreen extends StatefulWidget {
  const ExploreUserScreen({super.key});

  @override
  State<ExploreUserScreen> createState() => _ExploreUserScreenState();
}

class _ExploreUserScreenState extends State<ExploreUserScreen> {
  final _appointmentService = AppointmentService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(20),
          child: const Text(
            "Suas trilhas",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _appointmentService.getAll(
              isActive: true,
              isAvailable: true,
              hasUserParticipation: true,
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
                  child: Text("As suas trilhas aparecerão aqui."),
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
                    isPrimary: false,
                    appointment: appointment,
                    actionText: "Informações",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AppointmentDetailsScreen(
                            appointment: appointment,
                          ),
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
