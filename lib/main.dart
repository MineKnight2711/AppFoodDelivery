import 'package:app_food_2023/controller/user.dart';
import 'package:app_food_2023/screens/loading_screen/home_loading.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'controller/edit_employee.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.userChanges();
  await FirebaseAuth.instance.authStateChanges();
  await getCurrentUser();
  await convertToUserModel();
  if (loggedInUser?.Role != 'Customer') {
    await convertEmployeeToUserModel();
  } else {
    await convertToUserModel();
  }
  //Cố định chiều màn hình
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MaterialApp(
    initialRoute: 'welcome',
    debugShowCheckedModeBanner: false,
    routes: {
      // 'cart_test': (context) => CartTest(),
      // 'admin': (context) => AdminScreen(),
      // 'login': (context) => LoginScreen(),
      // 'home': (context) => AppHomeScreen(),
      // 'phone': (context) => MyPhone(),
      // 'verify': (context) => MyVerify(),
      // 'ratingTest': (context) => RatingTest(),
      // 'ratingBar': (context) => RatingBarScreen(),
      'welcome': (context) => LoadingHomeScreen(),
    },
  ));
}
