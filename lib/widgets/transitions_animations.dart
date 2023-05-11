import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

void zoominTransition(BuildContext context, Widget widget) async {
  Navigator.pushAndRemoveUntil<dynamic>(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = 0.0;
        var end = 1.0;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return ScaleTransition(
          scale: animation.drive(tween),
          child: child,
        );
      },
    ),
    (route) => false,
  );
}

void rotateTransition(BuildContext context, Widget widget) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Đang tải..."),
      duration: Duration(seconds: 2),
    ),
  );
  await Future.delayed(Duration(seconds: 2), () {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AppHomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return RotationTransition(
            turns: animation,
            child: child,
          );
        },
      ),
      (route) => false,
    );
  });
}

void slideinTransition(
    BuildContext context, Widget widget, bool allowBack) async {
  Navigator.pushAndRemoveUntil<dynamic>(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
    (route) => allowBack,
  );
}

void slideupTransition(BuildContext context, Widget widget) async {
  Navigator.pushAndRemoveUntil<dynamic>(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
    (route) => true,
  );
}

void refreshTransition(BuildContext context, Widget widget) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Đang tải..."),
      duration: Duration(seconds: 2),
    ),
  );

  Navigator.pushAndRemoveUntil<dynamic>(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(seconds: 1),
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
    (route) => false,
  );
}

void fadeinTransition(BuildContext context, Widget widget) async {
  Navigator.pushAndRemoveUntil<dynamic>(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
    (route) => true,
  );
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Đang tải..."),
      duration: Duration(seconds: 2),
    ),
  );
}
      //Hiệu ứng zoom vào--------------

      // PageRouteBuilder(
      //   pageBuilder: (context, animation, secondaryAnimation) => widget,
      //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //     var begin = 0.0;
      //     var end = 1.0;
      //     var curve = Curves.ease;

      //     var tween =
      //         Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      //     return ScaleTransition(
      //       scale: animation.drive(tween),
      //       child: child,
      //     );
      //   },
      // ),

      //Hiệu ứng chuyển trang--------------

      // PageRouteBuilder(
      //   pageBuilder: (context, animation, secondaryAnimation) =>
      //       AppHomeScreen(),
      //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //     var begin = Offset(1.0, 0.0);
      //     var end = Offset.zero;
      //     var curve = Curves.ease;

      //     var tween =
      //         Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      //     return SlideTransition(
      //       position: animation.drive(tween),
      //       child: child,
      //     );
      //   },
      // ),

      //Hiệu ứng mờ dần----------------

      // PageRouteBuilder(
      //   transitionDuration: const Duration(milliseconds: 500),
      //   pageBuilder: (context, animation, secondaryAnimation) =>
      //       AppHomeScreen(),
      //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //     return FadeTransition(
      //       opacity: animation,
      //       child: child,
      //     );
      //   },
      // ),

      //Hiệu ứng quay vòng----------------

      // PageRouteBuilder(
      //   pageBuilder: (context, animation, secondaryAnimation) =>
      //       AppHomeScreen(),
      //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //     return RotationTransition(
      //       turns: animation,
      //       child: child,
      //     );
      //   },
      // ),

      //Hiệu ứng trượt lên----------------

      //     PageRouteBuilder(
      //   pageBuilder: (context, animation, secondaryAnimation) => AppHomeScreen(),
      //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //     var begin = Offset(0.0, 1.0);
      //     var end = Offset.zero;
      //     var curve = Curves.ease;

      //     var tween = Tween(begin: begin, end: end)
      //         .chain(CurveTween(curve: curve));

      //     return SlideTransition(
      //       position: animation.drive(tween),
      //       child: child,
      //     );
      //   },
      // ),