import 'package:flutter_test/flutter_test.dart';
import 'package:trilhas_phb/helpers/validators.dart';

void main() {
  group('isGpxValid Tests', () {
    test('Valid GPX with waypoints', () {
      const gpxString = '''<?xml version="1.0" encoding="UTF-8"?>
      <gpx version="1.1" creator="Test">
        <wpt lat="37.7749" lon="-122.4194"><name>Test</name></wpt>
      </gpx>''';

      expect(isGpxValid(gpxString), isTrue);
    });

    test('Valid GPX with routes', () {
      const gpxString = '''<?xml version="1.0" encoding="UTF-8"?>
      <gpx version="1.1" creator="Test">
        <rte>
          <name>Sample Route</name>
          <rtept lat="37.7749" lon="-122.4194"></rtept>
        </rte>
      </gpx>''';

      expect(isGpxValid(gpxString), isTrue);
    });

    test('Valid GPX with tracks', () {
      const gpxString = '''<?xml version="1.0" encoding="UTF-8"?>
      <gpx version="1.1" creator="Test">
        <trk>
          <name>Sample Track</name>
          <trkseg>
            <trkpt lat="37.7749" lon="-122.4194"></trkpt>
          </trkseg>
        </trk>
      </gpx>''';

      expect(isGpxValid(gpxString), isTrue);
    });

    test('Invalid GPX - Missing root element', () {
      const gpxString = '''<?xml version="1.0" encoding="UTF-8"?>
      <invalid>
        <wpt lat="37.7749" lon="-122.4194"><name>Test</name></wpt>
      </invalid>''';

      expect(isGpxValid(gpxString), isFalse);
    });

    test('Invalid GPX - No valid child elements', () {
      const gpxString = '''<?xml version="1.0" encoding="UTF-8"?>
      <gpx version="1.1" creator="Test">
        <metadata>
          <desc>Sample metadata</desc>
        </metadata>
      </gpx>''';

      expect(isGpxValid(gpxString), isFalse);
    });

    test('Invalid GPX - Malformed XML', () {
      const gpxString = '''<?xml version="1.0" encoding="UTF-8"?>
      <gpx version="1.1" creator="Test">
        <wpt lat="37.7749" lon="-122.4194"><name>Test</name>
      </gpx>'''; // Missing closing </wpt>

      expect(isGpxValid(gpxString), isFalse);
    });

    test('Invalid GPX - Empty string', () {
      const gpxString = '';

      expect(isGpxValid(gpxString), isFalse);
    });

    test('Valid GPX - Extra whitespace and new lines', () {
      const gpxString = '''<?xml version="1.0" encoding="UTF-8"?>
      
      <gpx version="1.1" creator="Test">

        <trk>
          <name>Sample Track</name>
          <trkseg>
            <trkpt lat="37.7749" lon="-122.4194"></trkpt>
          </trkseg>
        </trk>

      </gpx>''';

      expect(isGpxValid(gpxString), isTrue);
    });
  });
}