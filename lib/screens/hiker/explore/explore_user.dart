import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/models/appointment.dart';
import 'package:trilhas_phb/screens/hiker/explore/details/appointment_details.dart';
import 'package:trilhas_phb/widgets/decorated_card.dart';
import 'package:trilhas_phb/widgets/loader.dart';

class ExploreUserScreen extends StatelessWidget {
  const ExploreUserScreen({
    super.key,
    required this.userAppointments,
    required this.isUserAppointmentsLoading,
    required this.isUserAppointmentsLoadingError,
    required this.onUpdate,
  });

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
                  return Stack(
                    children: <Widget>[
                      const Center(
                        child: Text("As suas trilhas aparecerão aqui."),
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
                  itemCount: userAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = userAppointments[index];
                    return DecoratedCard(
                      isPrimary: false,
                      appointment: appointment,
                      actionText: "Informações",
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (context) => AppointmentDetailsScreen(
                                  appointment: appointment,
                                ),
                              ),
                            )
                            .then((value) => onUpdate());
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
