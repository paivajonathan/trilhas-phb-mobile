import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/models/appointment.dart';
import 'package:trilhas_phb/screens/administrator/explore/edit/appointment/appointment_details.dart';
import 'package:trilhas_phb/screens/administrator/explore/register/appointment/hike_choice.dart';
import 'package:trilhas_phb/widgets/decorated_card.dart';
import 'package:trilhas_phb/widgets/loader.dart';

class ExploreAppointmentsScreen extends StatelessWidget {
  const ExploreAppointmentsScreen({
    super.key,
    required this.appointments,
    required this.isAppointmentsLoading,
    required this.isAppointmentsLoadingError,
    required this.onUpdate,
  });

  final List<AppointmentModel> appointments;
  final bool isAppointmentsLoading;
  final String? isAppointmentsLoadingError;
  final void Function() onUpdate;

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
                  ).then((value) {
                    if (value == null) return;
                    if (value) onUpdate();
                  });
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
          child: Builder(
            builder: (context) {
              if (isAppointmentsLoading) {
                return const Loader();
              }

              if (isAppointmentsLoadingError != null) {
                return Center(
                  child: Text(
                    isAppointmentsLoadingError!,
                  ),
                );
              }

              if (appointments.isEmpty) {
                return const Center(
                  child: Text("Os agendamentos aparecerão aqui."),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  onUpdate();
                },
                color: AppColors.primary,
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: appointments.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (context, value) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    return DecoratedCard(
                      appointment: appointment,
                      actionText: "Editar",
                      onTap: () {
                        onUpdate();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AppointmentDetailsScreen(appointmentId: appointment.id);
                            },
                          ),
                        ).then((value) {
                          if (value == null) return;
                          if (value) onUpdate();
                        });
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
