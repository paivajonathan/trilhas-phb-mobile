import 'package:trilhas_phb/models/hike.dart';

class AppointmentModel {
  AppointmentModel({
    required this.id,
    required this.datetime,
    required this.hike,
  });

  final int id;
  final DateTime datetime;
  final HikeModel hike;

  factory AppointmentModel.fromMap(Map<String, dynamic> map, String url) {
    return AppointmentModel(
      id: map["id"],
      datetime: DateTime.parse("${map["date"]} ${map["time"]}"),
      hike: HikeModel.fromMap(map["hike"], url)
    );
  }
}
