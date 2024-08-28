import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? Email;
  String? FirstName;
  String? LastName;
  String? Avatar;
  String? PhoneNumber;
  String? Address;
  String? Gender;
  String? Role;
  DateTime? BirthDay;

  UserModel(
      {this.Email,
      this.FirstName,
      this.LastName,
      this.Avatar,
      this.PhoneNumber,
      this.Address,
      this.BirthDay,
      this.Gender,
      this.Role});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      Email: map?['Email'],
      FirstName: map?['FirstName'],
      LastName: map?['LastName'],
      Avatar: map?['Avatar'],
      PhoneNumber: map?['PhoneNumber'],
      Address: map?['Address'],
      Gender: map?['Gender'],
      BirthDay: (map?['BirthDay'] as Timestamp?)?.toDate(),
      Role: map?['Role'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'Email': Email,
      'FirstName': FirstName,
      'LastName': LastName,
      'Avatar': Avatar,
      'PhoneNumber': PhoneNumber,
      'Address': Address,
      'Gender': Gender,
      'Role': Role,
      'BirthDay': BirthDay,
    };
  }
}
