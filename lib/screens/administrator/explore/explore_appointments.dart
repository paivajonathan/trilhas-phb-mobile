import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/screens/administrator/explore/register/hike_choice.dart';
import 'package:trilhas_phb/services/appointment.dart';
import 'package:trilhas_phb/widgets/decorated_card.dart';
import 'package:trilhas_phb/widgets/loader.dart';

class ExploreAppointmentsScreen extends StatefulWidget {
  const ExploreAppointmentsScreen({super.key});

  @override
  State<ExploreAppointmentsScreen> createState() =>
      _ExploreAppointmentsScreenState();
}

class _ExploreAppointmentsScreenState extends State<ExploreAppointmentsScreen> {
  final _appointmentService = AppointmentService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Trilhas agendadas",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return HikeChoiceScreen();
                      },
                    ),
                  ).then((value) => setState(() {}));
                },
                child: const Text(
                  "Agendar trilha",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _appointmentService.getAll(
              isActive: true,
              isAvailable: true,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error!.toString().replaceAll("Exception: ", ""),
                  ),
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
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, value) {
                  return const SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  final appointment = snapshot.data![index];
                  return DecoratedCard(
                    appointment: appointment,
                    actionText: "Editar",
                    onTap: () {
                      print("Navegando para a tela de editar...");
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
