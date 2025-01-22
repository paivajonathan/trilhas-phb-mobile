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

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map["id"],
      datetime: DateTime.parse("${map["date"]} ${map["time"]}"),
      isActive: map["is_active"],
      isAvailable: map["is_available"],
      hasUserParticipation: map["has_user_participation"],
      hike: HikeModel.fromMap(map["hike"]),
    );
  }

  String get readableDate {
    return "${datetime.day.toString().padLeft(2, '0')}/${datetime.month.toString().padLeft(2, '0')}/${datetime.year}";
  }

  String get readableTime {
    return "${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}";
  }

  String get fullReadableTime {
    String day = datetime.day.toString().padLeft(2, '0');
    String month = switch(datetime.month) {
      DateTime.january => "Janeiro",
      DateTime.february => "Fevereiro",
      DateTime.march => "Março",
      DateTime.april => "Abril",
      DateTime.may => "Maio",
      DateTime.june => "Junho",
      DateTime.july => "Julho",
      DateTime.august => "Agosto",
      DateTime.september => "Setembro",
      DateTime.october => "Outubro",
      DateTime.november => "Novembro",
      DateTime.december => "Dezembro",
      _ => "Inválido",
    };
    String time = readableTime;

    return "$day de $month, às $time";
  }
}
