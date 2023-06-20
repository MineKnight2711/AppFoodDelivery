import 'package:app_food_2023/appstyle/screensize_aspectratio/mediaquery.dart';
import 'package:flutter/material.dart';

class GenderSelectionWidget extends StatefulWidget {
  final String? gender;
  final ValueChanged<String>? onChanged;
  final double? size;
  GenderSelectionWidget({this.gender, this.onChanged, this.size});

  @override
  _GenderSelectionWidgetState createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.gender;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.scale(
          scale: widget.size ?? 1 / MediaAspectRatio(context, 2),
          child: Radio(
            value: 'Nam',
            groupValue: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value.toString();
                widget.onChanged!(value.toString());
              });
            },
            activeColor: Colors.blue,
          ),
        ),
        Text(
          'Nam',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(width: MediaWidth(context, 3.5)),
        Transform.scale(
          scale: widget.size ?? 1 / MediaAspectRatio(context, 2),
          child: Radio(
            value: 'Nữ',
            groupValue: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value.toString();
                widget.onChanged!(value.toString());
              });
            },
            activeColor: Colors.pink,
          ),
        ),
        Text('Nữ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            )),
      ],
    );
  }
}
