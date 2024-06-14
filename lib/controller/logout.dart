import 'package:app_food_2023/controller/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/loading_screen/logout_loading.dart';
import '../widgets/custom_widgets/message.dart';
import '../widgets/custom_widgets/transitions_animations.dart';
import 'admincontrollers/edit_employee.dart';

Future logOut(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.remove('email');
  user = null;
  loggedInUser = loggedInEmployee = null;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  _googleSignIn.signOut();
  await FirebaseAuth.instance.signOut();
  await FirebaseAuth.instance.userChanges();
  await FirebaseAuth.instance.authStateChanges();
  CustomSuccessMessage.showMessage('Đã đăng xuất');
  refreshTransition(context, LogoutLoadingScreen());
}
