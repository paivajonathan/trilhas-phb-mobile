import 'package:flutter/material.dart';
import 'package:trilhas_phb/models/hike.dart';

class AppointmentRegisterScreen extends StatefulWidget {
  const AppointmentRegisterScreen({super.key, required this.hike});

  final HikeModel hike;

  @override
  State<AppointmentRegisterScreen> createState() => _AppointmentRegisterScreenState();
}

class _AppointmentRegisterScreenState extends State<AppointmentRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.hike.name),
      ),
    );
  }
}