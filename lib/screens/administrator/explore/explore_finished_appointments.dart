import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/models/appointment.dart';
import 'package:trilhas_phb/screens/administrator/explore/frequency/frequency_register.dart';
import 'package:trilhas_phb/widgets/decorated_card.dart';
import 'package:trilhas_phb/widgets/loader.dart';

class ExploreFinishedAppointmentsScreen extends StatelessWidget {
  const ExploreFinishedAppointmentsScreen({
    super.key,
    required this.finishedAppointments,
    required this.isFinishedAppointmentsLoading,
    required this.isFinishedAppointmentsLoadingError,
    required this.onUpdate,
  });

  final List<AppointmentModel> finishedAppointments;
  final bool isFinishedAppointmentsLoading;
  final String? isFinishedAppointmentsLoadingError;
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
            padding: const EdgeInsets.all(20),
            child: const Text(
              "Trilhas concluídas",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (isFinishedAppointmentsLoading) {
                  return const Loader();
                }

                if (isFinishedAppointmentsLoadingError != null) {
                  return Center(
                    child: Text(
                      isFinishedAppointmentsLoadingError!,
                    ),
                  );
                }

                if (finishedAppointments.isEmpty) {
                  return Stack(
                    children: <Widget>[
                      const Center(
                        child: Text("As trilhas concluídas aparecerão aqui."),
                      ),
                      ListView()
                    ],
                  );
                }

                return ListView.separated(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: finishedAppointments.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (context, value) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    final appointment = finishedAppointments[index];
                    return DecoratedCard(
                      appointment: appointment,
                      actionText: "Frequência",
                      onTap: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FrequencyRegisterScreen(
                              appointment: appointment,
                            ),
                          ),
                        );

                        if (result == null) return;
                        if (!result) return;

                        onUpdate();
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
