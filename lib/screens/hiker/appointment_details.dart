import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/models/appointment.dart';
import 'package:trilhas_phb/services/participation.dart';
import 'package:trilhas_phb/widgets/decorated_button.dart';
import 'package:xml/xml.dart';
import 'package:flutter/foundation.dart';

List<LatLng> parseGpx(String gpxData) {
  final XmlDocument gpx = XmlDocument.parse(gpxData);
  final List<XmlElement> trackPoints = gpx.findAllElements('trkpt').toList();

  return trackPoints.map((trkpt) {
    final double lat = double.parse(trkpt.getAttribute('lat')!);
    final double lon = double.parse(trkpt.getAttribute('lon')!);
    return LatLng(lat, lon);
  }).toList();
}

LatLngBounds calculateBounds(List<LatLng> points) {
  if (points.isEmpty) {
    return LatLngBounds(
      const LatLng(-90.0, -180.0),
      const LatLng(90.0, 180.0),
    );
  }

  double minLat = points.first.latitude;
  double maxLat = points.first.latitude;
  double minLng = points.first.longitude;
  double maxLng = points.first.longitude;

  for (var point in points) {
    minLat = point.latitude < minLat ? point.latitude : minLat;
    maxLat = point.latitude > maxLat ? point.latitude : maxLat;
    minLng = point.longitude < minLng ? point.longitude : minLng;
    maxLng = point.longitude > maxLng ? point.longitude : maxLng;
  }

  return LatLngBounds(
    LatLng(minLat, minLng),
    LatLng(maxLat, maxLng),
  );
}

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
  List<LatLng> _routePoints = [];
  bool _isMapLoading = false;

  @override
  void initState() {
    super.initState();
    _loadGpx();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _loadGpx() async {
    try {
      setState(() => _isMapLoading = true);
      
      final response = await http.get(Uri.parse(widget.appointment.hike.gpxFile));

      if (response.statusCode == 200) {
        final gpxData = response.body;

        final points = await compute(parseGpx, gpxData);

        setState(() => _routePoints = points);
      } else {
        print("Ocorreu um erro no servidor.");
      }
    } catch (e) {
      print("Ocorreu um erro inesperado.");
    } finally {
      setState(() => _isMapLoading = false);
    }
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
          initialCenter: _routePoints.isNotEmpty
            ? _routePoints.last
            : const LatLng(0, 0),
          initialZoom: 15.0,
          maxZoom: 20.0,
          minZoom: 15.0,
          cameraConstraint: CameraConstraint.containCenter(bounds: calculateBounds(_routePoints))
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

class BottomDrawer extends StatefulWidget {
  const BottomDrawer({
    super.key,
    required AppointmentModel appointment,
  }) : _appointment = appointment;

  final AppointmentModel _appointment;

  @override
  State<BottomDrawer> createState() => _BottomDrawerState();
}

class _BottomDrawerState extends State<BottomDrawer> {
  final _participationService = ParticipationService();
  late bool _doesUserParticipate = widget._appointment.hasUserParticipation;
  bool _isButtonLoading = false;

  final double _maxHeight = 0.7;
  final double _minHeight = 0.075;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _handleParticipation(BuildContext context) async {
    try {
      setState(() => _isButtonLoading = true);

      if (_doesUserParticipate) {
        await _participationService.cancel(appointmentId: widget._appointment.id);
        setState(() => _doesUserParticipate = false);
      } else {
        await _participationService.create(appointmentId: widget._appointment.id);
        setState(() => _doesUserParticipate = true);
      }
    } catch (e) {
      if (!mounted) return;

      print(e.toString());
      
      late String message = _doesUserParticipate
        ? "Ocorreu um erro ao tentar cancelar a sua participação na trilha."
        : "Ocorreu um erro ao tentar fixar sua participação na trilha.";

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$message: ${e.toString()}")),
      );
    } finally {
      setState(() => _isButtonLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = widget._appointment.hike.name;
    String length = widget._appointment.hike.length.toString();
    String difficulty = widget._appointment.hike.readableDifficulty;
    String date = widget._appointment.readableDate;
    String time = widget._appointment.readableTime;
    String description = widget._appointment.hike.description;

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
                        itemCount: widget._appointment.hike.images.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Image.network(widget._appointment.hike.images[index],
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
                  padding: const EdgeInsets.all(24),
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
                  padding: const EdgeInsets.all(24),
                  child: DecoratedButton(
                    primary: _doesUserParticipate ? false : true,
                    text: _doesUserParticipate ? "CANCELAR INSCRIÇÃO" : "PARTICIPAR",
                    onPressed: () => _handleParticipation(context),
                    isLoading: _isButtonLoading,
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
