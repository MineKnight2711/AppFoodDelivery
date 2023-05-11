import 'package:app_food_2023/appstyle/screensize_aspectratio/mediaquery.dart';
import 'package:flutter/material.dart';

class AvatarContainer extends StatelessWidget {
  final bool isLoading;
  final String? avatarUrl;

  AvatarContainer({
    required this.isLoading,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenRotate(context)
          ? MediaHeight(context, 5)
          : MediaHeight(context, 2.4),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Stack(
              fit: StackFit.loose,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 140.0,
                      height: 140.0,
                      child: isLoading
                          ? CircularProgressIndicator()
                          : CircleAvatar(
                              radius: 100,
                              backgroundImage: NetworkImage(avatarUrl!),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String? helperText;
  final String? hintText;

  PasswordTextField({
    required this.controller,
    required this.onChanged,
    required this.helperText,
    required this.hintText,
  });

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: widget.controller,
              obscureText: !_passwordVisible,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: widget.hintText,
                helperText: widget.helperText,
                helperStyle: TextStyle(
                  color: Color.fromARGB(255, 24, 179, 0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(_passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
            ),
          ),
        ],
      ),
    );
  }
}
