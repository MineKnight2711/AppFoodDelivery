import 'package:app_food_2023/model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/homescreen_widgets/default_avatar.dart';
import '../widgets/homescreen_widgets/employee_avatar.dart';
import '../widgets/homescreen_widgets/notlogin.dart';
import '../widgets/homescreen_widgets/username_location.dart';

User? user;
UserModel? loggedInUser;
DateTime? dateTime, currentBirthDay;

Future<UserModel> getCurrentUser() async {
  await FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
    user = currentUser;
  });

  DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection("users").doc(user?.uid).get();

  if (userSnapshot.exists) {
    return UserModel.fromMap(userSnapshot.data());
  } else {
    return UserModel();
  }
}

convertToUserModel() async {
  UserModel user = await getCurrentUser();

  loggedInUser = user;
}

getUserBirthDay() async {
  await convertToUserModel();
  dateTime = loggedInUser?.BirthDay;
}

Widget showUserInfor(BuildContext context) {
  if (user != null) {
    return FutureBuilder<UserModel>(
      future: getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserModel userSnapShot = snapshot.data!;

          if (userSnapShot.Role == "Customer") {
            return userInfor(context, userSnapShot);
          } else if (userSnapShot.Role == "Delivery") {
            return shipperInfor(context, userSnapShot);
          } else if (userSnapShot.Role == "Admin") {
            return adminInfor(context, userSnapShot);
          }
        }
        return notLogin(context);
      },
    );
  }
  return notLogin(context);
}

Widget userImage() {
  if (user != null) {
    return FutureBuilder<UserModel>(
      future: getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserModel userSnapShot = snapshot.data!;
          bool isValidUrl(String url) {
            Uri uri = Uri.parse(url);
            return uri.isAbsolute &&
                (uri.scheme == "http" || uri.scheme == "https");
          }

          if (isValidUrl(userSnapShot.Avatar.toString())) {
            return Container(
              height: 50,
              width: 50,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(userSnapShot.Avatar.toString()),
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        }
        return defaultAvatar();
      },
    );
  }
  return defaultAvatar();
}

Widget userAvatar(BuildContext context) {
  if (user != null) {
    return FutureBuilder<UserModel>(
      future: getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserModel userSnapShot = snapshot.data!;
          if (userSnapShot.Role == "Customer") {
            return customerAvatar(context);
          } else if (userSnapShot.Role == "Admin") {
            return adminAvatar(context);
          } else if (userSnapShot.Role == "Delivery") {
            return deliveryAvatar(context);
          }
        }
        return notLoginAvatar(context);
      },
    );
  }
  return notLoginAvatar(context);
}
