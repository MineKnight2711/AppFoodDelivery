import 'package:flutter/material.dart';

import '../../appstyle/screensize_aspectratio/mediaquery.dart';

class MyTitleTextFieldWidget extends StatelessWidget {
  final String title;

  const MyTitleTextFieldWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaAspectRatio(context, 0.03),
        left: ScreenRotate(context)
            ? MediaAspectRatio(context, 0.03)
            : MediaAspectRatio(context, 0.05),
        right: ScreenRotate(context)
            ? MediaAspectRatio(context, 0.03)
            : MediaAspectRatio(context, 0.05),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TextInputWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  const TextInputWidget({
    Key? key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.focusNode,
    this.nextFocusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaAspectRatio(context, 0.5),
        left: ScreenRotate(context)
            ? MediaAspectRatio(context, 0.03)
            : MediaAspectRatio(context, 0.05),
        right: ScreenRotate(context)
            ? MediaAspectRatio(context, 0.03)
            : MediaAspectRatio(context, 0.05),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
              ),
              onChanged: onChanged,
              focusNode: focusNode,
              onSubmitted: (value) {
                focusNode?.unfocus();
                if (nextFocusNode != null) {
                  FocusScope.of(context).requestFocus(nextFocusNode);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyRoleDropdownWidget extends StatefulWidget {
  final ValueChanged<String>? onRoleSelected;
  final String? selectedRole;
  const MyRoleDropdownWidget({Key? key, this.onRoleSelected, this.selectedRole})
      : super(key: key);

  @override
  _MyRoleDropdownWidgetState createState() => _MyRoleDropdownWidgetState();
}

class _MyRoleDropdownWidgetState extends State<MyRoleDropdownWidget> {
  String? roleSelected; // Define the selected role in the state class

  @override
  void initState() {
    super.initState();
    roleSelected =
        widget.selectedRole; // Initialize the selected role in the state
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            child: DropdownButtonFormField<String>(
              value: roleSelected,
              items: [
                DropdownMenuItem(
                  child: Text('Admin'),
                  value: 'Admin',
                ),
                DropdownMenuItem(
                  child: Text('Delivery'),
                  value: 'Delivery',
                ),
              ],
              onChanged: (value) {
                setState(() {
                  roleSelected = value;
                });
                if (widget.onRoleSelected != null) {
                  widget.onRoleSelected!(roleSelected!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SaveCancelButtonsWidget extends StatelessWidget {
  final VoidCallback onSavePressed;
  final VoidCallback onCancelPressed;

  const SaveCancelButtonsWidget({
    Key? key,
    required this.onSavePressed,
    required this.onCancelPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                height: MediaHeight(context, 18),
                child: ElevatedButton.icon(
                  icon:
                      Icon(Icons.save, size: MediaAspectRatio(context, 0.025)),
                  label: Text(
                    'Lưu',
                    style: TextStyle(
                      fontSize: MediaAspectRatio(context, 0.023),
                      color: Colors.black,
                    ),
                  ),
                  onPressed: onSavePressed,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 14, 215, 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ),
            flex: 2,
          ),
          SizedBox(
            width: MediaWidth(context, 8),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                height: MediaHeight(context, 18),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.cancel,
                      size: MediaAspectRatio(context, 0.023)),
                  label: Text(
                    "Huỷ",
                    style: TextStyle(
                      fontSize: MediaAspectRatio(context, 0.025),
                      color: Colors.black,
                    ),
                  ),
                  onPressed: onCancelPressed,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }
}

String? radioVal = "";
Future<String> getRadioVal() {
  return Future.value(radioVal);
}

void updateRadioValue(String value) {
  radioVal = value;
}
