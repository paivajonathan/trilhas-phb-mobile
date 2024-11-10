class UserLoginModel {
  final int id;
  final String type;

  UserLoginModel(
    {
      required this.id,
      required this.type,
    }
  );

  factory UserLoginModel.fromMap(Map<String, dynamic> map) {
    return UserLoginModel(
      id: map["id"],
      type: map["type"],
    );
  }
}