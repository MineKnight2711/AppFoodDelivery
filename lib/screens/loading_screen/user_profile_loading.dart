import 'dart:async';

import 'package:app_food_2023/screens/admin/admin_screen.dart';
import 'package:flutter/material.dart';

class LoadingUserScreen extends StatefulWidget {
  @override
  _LoadingUserScreenState createState() => _LoadingUserScreenState();
}

class _LoadingUserScreenState extends State<LoadingUserScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => AdminScreen(),
        ),
        (route) => true, //if you want to disable back feature set to false
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animationController,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text("Đang tải vui lòng đợi..."),
            ],
          )),
        ),
      ),
    );
  }
}
