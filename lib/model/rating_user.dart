class UserRatingModel {
  String? firstName;
  String? secondName;
  String? Images;

  UserRatingModel({this.firstName, this.secondName, this.Images});

  // receiving data from server
  factory UserRatingModel.fromMap(map) {
    return UserRatingModel(
      firstName: map?['firstName'],
      secondName: map?['secondName'],
      Images: map?['Images'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'secondName': secondName,
      'Images': Images,
    };
  }
}
