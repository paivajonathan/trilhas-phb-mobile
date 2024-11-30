import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/models/appointment.dart';
import 'package:xml/xml.dart';

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
  double _sheetHeight = 0.5;
  final double _minHeight = 0.115;
  final double _maxHeight = 0.5;

  @override
  initState() {
    super.initState();
    _loadGpx();
  }

  Future<void> _loadGpx() async {
    try {
      setState(() => _isMapLoading = true);
      final response = await http.get(Uri.parse(widget.appointment.hike.gpxFile));

      if (response.statusCode == 200) {
        final gpxData = response.body;

        final XmlDocument gpx = XmlDocument.parse(gpxData);
        final List<XmlElement> trackPoints = gpx.findAllElements('trkpt').toList();
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
      mapView = const Center(child: CircularProgressIndicator(color: AppColors.primary));
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
        ]
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Informações", style: TextStyle(fontWeight: FontWeight.bold))
      ),
      body: Stack(
        children: [
          mapView,
          DraggableScrollableSheet(
            initialChildSize: _sheetHeight, // Começa com o modal meio aberto
            minChildSize: _minHeight, // A altura mínima (pontinha visível)
            maxChildSize: _maxHeight, // A altura máxima do modal
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _sheetHeight = _sheetHeight == _minHeight ? _maxHeight : _minHeight;
                        });
                      },
                      child: Container(
                        height: 75,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text('Conteúdo do Modal'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      )
    );
  }
}