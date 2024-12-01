import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/models/appointment.dart';
import 'package:trilhas_phb/widgets/decorated_button.dart';
import 'package:xml/xml.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({
    super.key,
    required this.appointment,
  });

  final AppointmentModel appointment;

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  List<LatLng> _routePoints = [];
  bool _isMapLoading = false;

  @override
  initState() {
    super.initState();
    _loadGpx();
  }

  Future<void> _loadGpx() async {
    try {
      setState(() => _isMapLoading = true);
      final response =
          await http.get(Uri.parse(widget.appointment.hike.gpxFile));

      if (response.statusCode == 200) {
        final gpxData = response.body;

        final XmlDocument gpx = XmlDocument.parse(gpxData);
        final List<XmlElement> trackPoints =
            gpx.findAllElements('trkpt').toList();
        final List<LatLng> points = trackPoints.map((trkpt) {
          final double lat = double.parse(trkpt.getAttribute('lat')!);
          final double lon = double.parse(trkpt.getAttribute('lon')!);
          return LatLng(lat, lon);
        }).toList();

        setState(() {
          _routePoints = points;
          _isMapLoading = false;
        });
      } else {
        print("Ocorreu um erro no servidor.");
      }
    } catch (e) {
      print("Ocorreu um erro inesperado.");
    }
  }

  LatLng calculateRouteCenter(List<LatLng> points) {
    double totalLat = 0;
    double totalLng = 0;

    for (var point in points) {
      totalLat += point.latitude;
      totalLng += point.longitude;
    }

    final avgLat = totalLat / points.length;
    final avgLng = (totalLng / points.length);

    return LatLng(avgLat, avgLng);
  }

  @override
  Widget build(BuildContext context) {
    late Widget mapView;

    if (_isMapLoading) {
      mapView = const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    } else {
      mapView = FlutterMap(
        options: MapOptions(
          initialCenter: calculateRouteCenter(_routePoints),
          initialZoom: 11.5,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          if (_routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: _routePoints,
                  color: AppColors.primary,
                  strokeWidth: 4.0,
                ),
              ],
            )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Informações",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          mapView,
          BottomDrawer(appointment: widget.appointment),
        ],
      ),
    );
  }
}

class BottomDrawer extends StatelessWidget {
  const BottomDrawer({
    super.key,
    required AppointmentModel appointment,
  }) : _appointment = appointment;

  final AppointmentModel _appointment;
  final double _maxHeight = 0.7;
  final double _minHeight = 0.075;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: _minHeight,
      maxChildSize: _maxHeight,
      initialChildSize: _maxHeight,
      snapSizes: [_minHeight, _maxHeight],
      snap: true,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Container(
                    width: 100.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _appointment.hike.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 25),
                      Text("DISTÂNCIA: ${_appointment.hike.length.toString()}"),
                      Text("DIFICULDADE: ${_appointment.hike.difficulty}"),
                      Text("DATA: ${_appointment.datetime.day}"),
                      Text("HORÁRIO: ${_appointment.datetime.hour}"),
                      const SizedBox(height: 25),
                      Text("Sobre"),
                      Text(_appointment.hike.description),
                      const SizedBox(height: 25,),
                      DecoratedButton(
                        primary: _appointment.hasUserParticipation
                          ? false
                          : true,
                        text: _appointment.hasUserParticipation
                          ? "CANCELAR INSCRIÇÃO"
                          : "PARTICIPAR",
                        onPressed: () {
                          print("Testando");
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
