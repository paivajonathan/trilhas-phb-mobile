import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:xml/xml.dart';

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
    return LatLngBounds(const LatLng(-90.0, -180.0), const LatLng(90.0, 180.0));
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
