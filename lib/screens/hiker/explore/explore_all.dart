import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/models/appointment.dart';
import 'package:trilhas_phb/screens/hiker/explore/details/appointment_details.dart';
import 'package:trilhas_phb/widgets/decorated_card.dart';
import 'package:trilhas_phb/widgets/decorated_list_tile.dart';
import 'package:trilhas_phb/widgets/loader.dart';

class ExploreAllScreen extends StatelessWidget {
  const ExploreAllScreen({
    super.key,
    required this.availableAppointments,
    required this.isAvailableAppointmentsLoading,
    required this.isAvailableAppointmentsLoadingError,
    required this.userAppointments,
    required this.isUserAppointmentsLoading,
    required this.isUserAppointmentsLoadingError,
    required this.onUpdate,
  });

  final List<AppointmentModel> availableAppointments;
  final bool isAvailableAppointmentsLoading;
  final String? isAvailableAppointmentsLoadingError;

  final List<AppointmentModel> userAppointments;
  final bool isUserAppointmentsLoading;
  final String? isUserAppointmentsLoadingError;

  final void Function() onUpdate;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        onUpdate();
      },
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(20),
            child: const Text(
              "Trilhas agendadas",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 250,
            alignment: Alignment.center,
            child: Builder(
              builder: (context) {
                if (isAvailableAppointmentsLoading) {
                  return const Loader();
                }
      
                if (isAvailableAppointmentsLoadingError != null) {
                  return Center(
                    child: Text(isAvailableAppointmentsLoadingError!),
                  );
                }
      
                if (availableAppointments.isEmpty) {
                  return const Center(
                    child: Text("Os agendamentos aparecerão aqui."),
                  );
                }
      
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  separatorBuilder: (context, value) => const SizedBox(width: 10),
                  itemCount: availableAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = availableAppointments[index];
                    return Container(
                      alignment: Alignment.center,
                      child: DecoratedCard(
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
                          ).then((value) => onUpdate());
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
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
            child: Builder(
              builder: (context) {
                if (isUserAppointmentsLoading) {
                  return const Loader();
                }
                  
                if (isUserAppointmentsLoadingError != null) {
                  return Center(
                    child: Text(isUserAppointmentsLoadingError!),
                  );
                }
                  
                if (userAppointments.isEmpty) {
                  return const Center(
                    child: Text("As suas trilhas aparecerão aqui."),
                  );
                }
                  
                return ListView.separated(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  separatorBuilder: (context, value) =>
                      const SizedBox(height: 10),
                  itemCount: userAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = userAppointments[index];
                    return DecoratedListTile(
                      appointment: appointment,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AppointmentDetailsScreen(
                                appointment: appointment,
                              );
                            },
                          ),
                        ).then((value) => onUpdate());
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
