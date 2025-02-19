import 'package:flutter_test/flutter_test.dart';
import 'package:trilhas_phb/helpers/map.dart';

void main() {
  late String trksGpx;
  late String rtesGpx;
  late String wptsGpx;

  setUpAll(() {
    trksGpx = """
<?xml version="1.0" encoding="UTF-8"?>
<gpx version="1.1" creator="MyApp">
  <trk>
    <name>Sample Track</name>
    <trkseg>
      <trkpt lat="37.7749" lon="-122.4194">
        <ele>10</ele>
      </trkpt>
      <trkpt lat="37.7750" lon="-122.4195">
        <ele>15</ele>
      </trkpt>
      <trkpt lat="37.7751" lon="-122.4196">
        <ele>20</ele>
      </trkpt>
    </trkseg>
  </trk>
</gpx>
""";

    rtesGpx = """
<?xml version="1.0" encoding="UTF-8"?>
<gpx version="1.1" creator="MyApp">
  <rte>
    <name>Sample Route</name>
    <rtept lat="37.7749" lon="-122.4194">
      <ele>10</ele>
    </rtept>
    <rtept lat="37.7750" lon="-122.4195">
      <ele>15</ele>
    </rtept>
    <rtept lat="37.7751" lon="-122.4196">
      <ele>20</ele>
    </rtept>
  </rte>
</gpx>
""";

    wptsGpx = """
<?xml version="1.0" encoding="UTF-8"?>
<gpx version="1.1" creator="MyApp">
  <wpt lat="37.7749" lon="-122.4194">
    <name>Waypoint 1</name>
    <ele>10</ele>
  </wpt>
  <wpt lat="37.7750" lon="-122.4195">
    <name>Waypoint 2</name>
    <ele>15</ele>
  </wpt>
  <wpt lat="37.7751" lon="-122.4196">
    <name>Waypoint 3</name>
    <ele>20</ele>
  </wpt>
</gpx>
""";
  });

  test('Tracks GPX test', () {
    expect(parseGpx(trksGpx), isNotEmpty);
  });

  test('Routes GPX test', () {
    expect(parseGpx(rtesGpx), isNotEmpty);
  });

  test('Waypoints GPX test', () {
    expect(parseGpx(wptsGpx), isNotEmpty);
  });

  test('Invalid GPX test', () {
    expect(parseGpx(''), isEmpty);
    expect(parseGpx('fdasfadssaf'), isEmpty);
  });
}
