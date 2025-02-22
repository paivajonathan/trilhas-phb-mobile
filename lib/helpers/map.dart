import 'package:flutter_map/flutter_map.dart';
import 'package:gpx/gpx.dart';
import 'package:latlong2/latlong.dart';
import 'package:trilhas_phb/helpers/validators.dart';

List<LatLng> parseGpx(String gpxData) {
  List<LatLng> result = [];

  if (!isGpxValid(gpxData)) {
    return result;
  }

  Gpx gpx = GpxReader().fromString(gpxData);

  if (gpx.trks.isNotEmpty) {
    for (int i = 0; i < gpx.trks.length; i++) {
      for (int j = 0; j < gpx.trks[i].trksegs.length; j++) {
        for (int k = 0; k < gpx.trks[i].trksegs[j].trkpts.length; k++) {
          double latitude = gpx.trks[i].trksegs[j].trkpts[k].lat!;
          double longitude = gpx.trks[i].trksegs[j].trkpts[k].lon!;
          
          result.add(LatLng(latitude, longitude));
        }
      }
    }
  } else if (gpx.rtes.isNotEmpty) {
    for (int i = 0; i < gpx.rtes.length; i++) {
      for (int j = 0; j < gpx.rtes[i].rtepts.length; j++) {
        double latitude = gpx.rtes[i].rtepts[j].lat!;
        double longitude = gpx.rtes[i].rtepts[j].lon!;
        
        result.add(LatLng(latitude, longitude));
      }
    }
  } else if (gpx.wpts.isNotEmpty) {
    for (int i = 0; i < gpx.wpts.length; i++) {
      double latitude = gpx.wpts[i].lat!;
      double longitude = gpx.wpts[i].lon!;
      
      result.add(LatLng(latitude, longitude));
    }
  }

  return result;
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
