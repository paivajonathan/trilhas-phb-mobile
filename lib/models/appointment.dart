import 'package:trilhas_phb/models/hike.dart';

class AppointmentModel {
  AppointmentModel({
    required this.id,
    required this.datetime,
    required this.hike,
    required this.isActive,
    required this.isAvailable,
    required this.hasUserParticipation,
  });

  final int id;
  final DateTime datetime;
  final bool isActive;
  final bool isAvailable;
  final bool hasUserParticipation;
  final HikeModel hike;

  factory AppointmentModel.fromMap(Map<String, dynamic> map, String url) {
    return AppointmentModel(
      id: map["id"],
      datetime: DateTime.parse("${map["date"]} ${map["time"]}"),
      isActive: map["is_active"],
      isAvailable: map["is_available"],
      hasUserParticipation: map["has_user_participation"],
      hike: HikeModel.fromMap(map["hike"], url)
    );
  }
}
