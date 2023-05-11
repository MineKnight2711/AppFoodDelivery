import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

Future<String> uploadAvatar(String userID) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  ByteData imageData = await rootBundle.load('assets/images/profile.png');
  Uint8List imageBytes = imageData.buffer.asUint8List();

  // Create a reference to the image file in Firebase Storage

  Reference storageRef = storage.ref().child('userAvatar/user_${userID}.jpg');

  // Upload the image to Firebase Storage
  UploadTask uploadTask = storageRef.putData(imageBytes);
  TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
  String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}
