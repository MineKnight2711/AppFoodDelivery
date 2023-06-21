import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLeading;
  final VoidCallback onPressed;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  CustomAppBar(
      {this.title,
      this.showLeading = true,
      required this.onPressed,
      this.bottom,
      this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: showLeading
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
              onPressed: onPressed,
            )
          : null,
      actions: actions,
      title: Text(
        title ?? "",
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
