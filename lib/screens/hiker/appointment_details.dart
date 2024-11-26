import 'package:flutter/material.dart';
import 'package:trilhas_phb/models/appointment.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({
    super.key,
    required this.appointment,
  });

  final AppointmentModel appointment;

  @override
  State<AppointmentDetailsScreen> createState() => _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(widget.appointment.hike.name)
      ),
    );
  }
}