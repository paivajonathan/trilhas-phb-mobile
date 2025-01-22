import 'package:trilhas_phb/models/appointment.dart';
import 'package:trilhas_phb/models/hike.dart';
import 'package:trilhas_phb/services/hike.dart';
import 'package:trilhas_phb/helpers/map.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';

class MapView extends StatelessWidget {
  MapView({
    super.key,
    this.appointment,
    this.hike,
  }) : assert((appointment != null && hike == null) || (appointment == null && hike != null), "É necessário um Agendamento ou uma Trilha para esse Widget.");

  final AppointmentModel? appointment;
  final HikeModel? hike;

  final _hikeService = HikeService();

  @override
  Widget build(BuildContext context) {
    String gpxFile = (appointment != null) ? appointment!.hike.gpxFile : hike!.gpxFile;

    return FutureBuilder(
      future: _hikeService.loadGpxPoints(gpxFile: gpxFile),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error!.toString()),
          );
        }

        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text("Não há dados para mostrar."),
          );
        }

        return FlutterMap(
          options: MapOptions(
            initialCenter: snapshot.data!.last,
            initialZoom: 15.0,
            minZoom: 12.5,
            maxZoom: 17.5,
            cameraConstraint: CameraConstraint.containCenter(
              bounds: calculateBounds(snapshot.data!),
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: snapshot.data!,
                  color: AppColors.primary,
                  strokeWidth: 4.0,
                ),
              ],
            )
          ],
        );
      },
    );
  }
}