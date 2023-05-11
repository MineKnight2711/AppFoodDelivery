import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LocationDropdown extends StatefulWidget {
  const LocationDropdown({Key? key}) : super(key: key);

  @override
  _LocationDropdownState createState() => _LocationDropdownState();
}

class _LocationDropdownState extends State<LocationDropdown> {
  bool _isExpanded = false;
  TextEditingController _editingController = TextEditingController();
  String? _inputValue = "";
  final _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _loadInputValue();
  }

  Future<void> _loadInputValue() async {
    final prefs = await SharedPreferences.getInstance();
    final inputValue = prefs.getString('custom_location');
    if (inputValue != null) {
      setState(() {
        _editingController.text = inputValue;
      });
    }
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (!_isExpanded) {
        _focusNode.unfocus();
      }
    });
  }

  Future<void> _saveInputValue() async {
    final prefs = await SharedPreferences.getInstance();
    print(_inputValue);
    await prefs.setString('custom_location', _inputValue ?? '');
  }

  Future<void> _choseLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('diachiHienTai', _inputValue ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleExpanded,
          child: Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.home_outlined),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Nhà'),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: _isExpanded ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 150),
          margin: EdgeInsets.only(top: 10, left: 5, right: 5),
          height: _isExpanded ? 70 : 0,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter text',
                    border: InputBorder.none,
                  ),
                  controller: _editingController,
                  minLines: 1,
                  maxLines: 4,
                  focusNode: _focusNode,
                ),
              ),
              TextButton(
                onPressed: () {
                  _choseLocation().then((value) {
                    Navigator.of(context).pop;
                  });
                },
                child: Text('Chọn'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _inputValue = _editingController.text;
                  });
                  _saveInputValue();
                  _toggleExpanded();
                },
                child: Text('Lưu'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
