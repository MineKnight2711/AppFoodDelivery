import 'package:cloud_firestore/cloud_firestore.dart';

class DeliverModel {
  String? id;
  String? Avatar;
  String? LastName;
  String? FirstName;
  String? PhoneNumber;
  bool isSelected;

  DeliverModel({
    this.id,
    this.Avatar,
    this.LastName,
    this.FirstName,
    this.PhoneNumber,
    this.isSelected = false,
  });
  factory DeliverModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return DeliverModel(
      id: snapshot.id,
      Avatar: data['Avatar'],
      LastName: data['LastName'],
      FirstName: data['FirstName'],
      PhoneNumber: data['PhoneNumber'],
      isSelected: data['isSelected'] ?? false,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'Avatar': Avatar,
      'LastName': LastName,
      'FirstName': FirstName,
      'PhoneNumber': PhoneNumber,
      'isSelected': isSelected,
    };
  }
}
