import 'package:flutter/material.dart';

import '../../appstyle/screensize_aspectratio/mediaquery.dart';

class BirthdayDatePickerWidget extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onChanged;

  BirthdayDatePickerWidget({this.initialDate, this.onChanged});

  @override
  _BirthdayDatePickerWidgetState createState() =>
      _BirthdayDatePickerWidgetState();
}

class _BirthdayDatePickerWidgetState extends State<BirthdayDatePickerWidget> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: MediaWidth(context, 30)),
            child: Container(
              height: ScreenRotate(context)
                  ? MediaHeight(context, 18)
                  : MediaHeight(context, 9),
              padding: EdgeInsets.only(
                  left: MediaWidth(context, 16),
                  right: MediaWidth(context, 16)),
              child: ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "${_selectedDate?.day ?? "Ngày"}/${_selectedDate?.month ?? "Tháng"}/${_selectedDate?.year ?? "Năm"}",
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    Icon(Icons.calendar_today),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.green,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: ColorScheme.light(primary: Colors.green)
                .copyWith(secondary: Colors.green),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.onChanged!(picked);
      });
    }
  }
}
