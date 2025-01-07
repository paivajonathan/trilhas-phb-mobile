import 'package:trilhas_phb/models/appointment.dart';
import 'package:trilhas_phb/services/hike.dart';
import 'package:trilhas_phb/helpers/map.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';

class MapView extends StatelessWidget {
  MapView({
    super.key,
    required AppointmentModel appointment,
  }) : _appointment = appointment;

  final AppointmentModel _appointment;

  final _hikeService = HikeService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _hikeService.loadGpx(gpxFile: _appointment.hike.gpxFile),
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