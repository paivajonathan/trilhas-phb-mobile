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

  @override
  setState(void Function() fn) {
    if (mounted) {
      super.setState(fn);
    }
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
          initialCenter: _routePoints.last,
          initialZoom: 15.0,
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
    late String name;
    late String length;
    late String difficulty;
    late String date;
    late String time;
    late String description;

    if (_appointment != null) {
      name = _appointment.hike.name;
      length = _appointment.hike.length.toString();
      difficulty = switch(_appointment.hike.difficulty) {
        "H" => "DIFÍCIL",
        "M" => "MÉDIO",
        "E" => "FÁCIL",
        _ => "INVÁLIDO",
      };
      date = "${_appointment.datetime.day}/${_appointment.datetime.month.toString().padLeft(2, '0')}/${_appointment.datetime.year}";
      time = "${_appointment.datetime.hour.toString()}:${_appointment.datetime.minute.toString()}";
      description = _appointment.hike.description;
    }

    return DraggableScrollableSheet(
      minChildSize: _minHeight,
      maxChildSize: _maxHeight,
      initialChildSize: _maxHeight,
      snapSizes: [_minHeight, _maxHeight],
      snap: true,
      builder: (_, controller) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 250,
                      child: PageView.builder(
                        itemCount: _appointment.hike.images.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Image.network(_appointment.hike.images[index],
                              fit: BoxFit.cover);
                        },
                      ),
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Container(
                        width: 100.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 25),
                      Text("DISTÂNCIA: $length"),
                      Text("DIFICULDADE: $difficulty"),
                      Text("DATA: $date"),
                      Text("HORÁRIO: $time"),
                      const SizedBox(height: 25),
                      const Text("Sobre"),
                      Text(description),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: DecoratedButton(
                    primary: _appointment.hasUserParticipation ? false : true,
                    text: _appointment.hasUserParticipation
                        ? "CANCELAR INSCRIÇÃO"
                        : "PARTICIPAR",
                    onPressed: () {
                      print("Testando");
                    },
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
