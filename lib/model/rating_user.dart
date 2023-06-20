class UserRatingModel {
  String? FirstName;
  String? LastName;
  String? Avatar;

  UserRatingModel({this.FirstName, this.LastName, this.Avatar});

  // receiving data from server
  factory UserRatingModel.fromMap(map) {
    return UserRatingModel(
      FirstName: map?['FirstName'],
      LastName: map?['LastName'],
      Avatar: map?['Avatar'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'FirstName': FirstName,
      'LastName': LastName,
      'Avatar': Avatar,
    };
  }
}
