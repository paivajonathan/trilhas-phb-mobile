import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/models/appointment.dart';
import 'package:trilhas_phb/screens/hiker/explore/details/appointment_details.dart';
import 'package:trilhas_phb/widgets/decorated_card.dart';
import 'package:trilhas_phb/widgets/loader.dart';

class ExploreAvailableScreen extends StatelessWidget {
  const ExploreAvailableScreen({
    super.key,
    required this.availableAppointments,
    required this.isAvailableAppointmentsLoading,
    required this.isAvailableAppointmentsLoadingError,
    required this.onUpdate,
  });

  final List<AppointmentModel> availableAppointments;
  final bool isAvailableAppointmentsLoading;
  final String? isAvailableAppointmentsLoadingError;
  final void Function() onUpdate;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: Colors.white,
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
          Expanded(
            child: Builder(
              builder: (context) {
                if (isAvailableAppointmentsLoading) {
                  return const Loader();
                }
      
                if (isAvailableAppointmentsLoadingError != null) {
                  return Stack(
                    children: <Widget>[
                      Center(
                        child: Text(isAvailableAppointmentsLoadingError!),
                      ),
                      ListView()
                    ],
                  );
                }
      
                if (availableAppointments.isEmpty) {
                    return Stack(
                      children: <Widget>[
                        const Center(
                          child: Text("Os agendamentos aparecerão aqui."),
                        ),
                        ListView()
                      ],
                    );
                }
      
                return ListView.separated(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  separatorBuilder: (context, value) =>
                      const SizedBox(height: 10),
                  itemCount: availableAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = availableAppointments[index];
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
