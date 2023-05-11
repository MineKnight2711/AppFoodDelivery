import 'dart:async';

import 'package:app_food_2023/screens/home_screen.dart';
import 'package:app_food_2023/widgets/transitions_animations.dart';
import 'package:flutter/material.dart';

class LogoutLoadingScreen extends StatefulWidget {
  @override
  _LogoutLoadingScreenState createState() => _LogoutLoadingScreenState();
}

class _LogoutLoadingScreenState extends State<LogoutLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();
    Timer(Duration(seconds: 3), () {
      zoominTransition(context, AppHomeScreen());
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
