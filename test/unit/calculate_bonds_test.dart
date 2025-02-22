import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:trilhas_phb/helpers/map.dart';

void main() {
  group('calculateBounds Tests', () {
    test('Empty list should return full-world bounds', () {
      final bounds = calculateBounds([]);

      expect(bounds.southWest.latitude, -90.0);
      expect(bounds.southWest.longitude, -180.0);
      expect(bounds.northEast.latitude, 90.0);
      expect(bounds.northEast.longitude, 180.0);
    });

    test('Single point should return bounds equal to that point', () {
      final points = [LatLng(37.7749, -122.4194)];
      final bounds = calculateBounds(points);

      expect(bounds.southWest, equals(bounds.northEast));
      expect(bounds.southWest.latitude, 37.7749);
      expect(bounds.southWest.longitude, -122.4194);
    });

    test('Two points should return correct bounds', () {
      final points = [
        LatLng(34.0522, -118.2437), // Los Angeles
        LatLng(40.7128, -74.0060)   // New York
      ];
      final bounds = calculateBounds(points);

      expect(bounds.southWest.latitude, 34.0522);
      expect(bounds.southWest.longitude, -118.2437);
      expect(bounds.northEast.latitude, 40.7128);
      expect(bounds.northEast.longitude, -74.0060);
    });

    test('Multiple points across lat/lng extremes', () {
      final points = [
        LatLng(-45.0, -170.0),
        LatLng(45.0, 170.0),
        LatLng(-10.0, 100.0),
        LatLng(10.0, -100.0)
      ];
      final bounds = calculateBounds(points);

      expect(bounds.southWest.latitude, -45.0);
      expect(bounds.southWest.longitude, -170.0);
      expect(bounds.northEast.latitude, 45.0);
      expect(bounds.northEast.longitude, 170.0);
    });

    test('Handles negative and positive longitudes correctly', () {
      final points = [
        LatLng(10.0, -50.0),
        LatLng(-10.0, 50.0)
      ];
      final bounds = calculateBounds(points);

      expect(bounds.southWest.latitude, -10.0);
      expect(bounds.southWest.longitude, -50.0);
      expect(bounds.northEast.latitude, 10.0);
      expect(bounds.northEast.longitude, 50.0);
    });

    test('Handles equator and prime meridian correctly', () {
      final points = [
        LatLng(0.0, 0.0),  // Origin
        LatLng(5.0, 5.0)
      ];
      final bounds = calculateBounds(points);

      expect(bounds.southWest.latitude, 0.0);
      expect(bounds.southWest.longitude, 0.0);
      expect(bounds.northEast.latitude, 5.0);
      expect(bounds.northEast.longitude, 5.0);
    });
  });
}
