class UserDataModel {
  final int id;
  final String type;

  UserDataModel(
    {
      required this.id,
      required this.type,
    }
  );

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      id: map["id"],
      type: map["type"],
    );
  }
}