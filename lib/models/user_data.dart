import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class UserProfileModel {
  final int userId;
  final String userEmail;
  final String userType;
  final bool userIsAccepted;
  final bool userIsActive;
  
  final int profileId;
  final String profileFullName;
  final String profileCellphone;
  final DateTime profileBirthDate;
  final String profileNeighborhoodName;
  final int profileStars;
  final bool profileIsActive;

  UserProfileModel(
    {
      required this.userId,
      required this.userEmail,
      required this.userType,
      required this.userIsAccepted,
      required this.userIsActive,
      
      required this.profileId,
      required this.profileFullName,
      required this.profileCellphone,
      required this.profileBirthDate,
      required this.profileNeighborhoodName,
      required this.profileStars,
      required this.profileIsActive,
    }
  );

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    final userMap = map["user"];
    final profileMap = map["profile"];

    return UserProfileModel(
      userId: userMap["id"],
      userEmail: userMap["email"],
      userType: userMap["user_type"],
      userIsAccepted: userMap["is_accepted"],
      userIsActive: userMap["is_active"],

      profileId: profileMap["id"],
      profileFullName: profileMap["full_name"],
      profileCellphone: profileMap["cellphone"],
      profileBirthDate: DateTime.parse(profileMap["birth_date"]),
      profileNeighborhoodName: profileMap["neighborhood_name"] ?? "Sem informações",
      profileStars: profileMap["stars"],
      profileIsActive: profileMap["is_active"],
    );
  }

  String get firstLastName {
    final names = profileFullName.split(" ");
    
    if (names.length == 1) {
      return names.first;
    }

    return "${names.first} ${names.last}";
  }

  String get readableBirthDate {
    return "${profileBirthDate.day.toString().padLeft(2, '0')}/${profileBirthDate.month.toString().padLeft(2, '0')}/${profileBirthDate.year}";
  }

  String get readableCellphone {
    final controller = MaskedTextController(
      text: profileCellphone,
      mask: "(00) 0 0000-0000",
    );
    return controller.text;
  }
}