class ParticipationModel {
  int id;
  String status;
  int profileId;
  String profileName;
  int appointmentId;
  String hikeName;
  bool isActive;

  ParticipationModel({
    required this.id,
    required this.status,
    required this.profileId,
    required this.profileName,
    required this.appointmentId,
    required this.hikeName,
    required this.isActive,
  });

  factory ParticipationModel.fromMap(Map<String, dynamic> map) {
    return ParticipationModel(
      id: map["id"],
      status: map["status"],
      profileId: map["profile_id"],
      profileName: map["profile_name"],
      appointmentId: map["appointment_id"],
      hikeName: map["hike_name"],
      isActive: map["is_active"],
    );
  }

  ParticipationModel copyWith({
    int? id,
    String? status,
    int? profileId,
    String? profileName,
    int? appointmentId,
    String? hikeName,
    bool? isActive,
  }) {
    return ParticipationModel(
      id: id ?? this.id,
      status: status ?? this.status,
      profileId: profileId ?? this.profileId,
      profileName: profileName ?? this.profileName,
      appointmentId: appointmentId ?? this.profileId,
      hikeName: hikeName ?? this.hikeName,
      isActive: isActive ?? this.isActive,
    );
  }
}
