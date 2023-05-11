import 'package:cloud_firestore/cloud_firestore.dart';

class DishModel {
  String? id;
  String? Name;
  String? Image;
  double? Price;

  DishModel({
    required this.id,
    required this.Name,
    required this.Image,
    required this.Price,
  });

  factory DishModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return DishModel(
      id: snapshot.id,
      Name: data['Name'],
      Image: data['Image'],
      Price: data['Price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Name': Name,
      'Image': Image,
      'Price': Price,
    };
  }
}
