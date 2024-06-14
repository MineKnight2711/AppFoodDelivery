import 'package:app_food_2023/controller/customercontrollers/check_out.dart';
import 'package:app_food_2023/widgets/custom_widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/user.dart';

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
  final controller = Get.find<CheckOutController>();
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

    await prefs.setString('custom_location', _inputValue ?? '');
    await prefs.setString('diachiHienTai', _inputValue ?? '');

    await controller.getLocation();
    CustomSnackBar.showCustomSnackBar(context, 'Đã chọn ${_inputValue}', 2);
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
                Icon(Icons.public_rounded),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Khác...'),
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
              Container(
                width: 1.5,
                height: 20,
                color: Colors.black,
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

class HomeLocationDropdown extends StatefulWidget {
  const HomeLocationDropdown({Key? key}) : super(key: key);

  @override
  _HomeLocationDropdownState createState() => _HomeLocationDropdownState();
}

class _HomeLocationDropdownState extends State<HomeLocationDropdown> {
  bool _isExpanded = false;
  String? _inputValue = '';
  final controller = Get.find<CheckOutController>();
  @override
  void initState() {
    super.initState();
    _loadInputValue();
  }

  Future<String> _loadInputValue() async {
    if (user != null) {
      final prefs = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      _inputValue = prefs.data()?["Address"];

      return prefs.data()?["Address"];
    }
    return '';
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Future<void> _choseLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('diachiHienTai', _inputValue ?? '');
    await controller.getLocation();
    CustomSnackBar.showCustomSnackBar(context, 'Đã chọn ${_inputValue}', 2);
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
          child: FutureBuilder<String>(
              future: _loadInputValue(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        '${snapshot.data}',
                        style: GoogleFonts.roboto(fontSize: 15.5),
                      )),
                      Container(
                        width: 1.5,
                        height: 20,
                        color: Colors.black,
                      ),
                      TextButton(
                        onPressed: () {
                          _choseLocation();
                          _toggleExpanded();

                          Navigator.of(context).pop;
                        },
                        child: Text('Lưu'),
                      ),
                    ],
                  );
                } else {
                  _loadInputValue();
                  return Center(
                    child: Text("Bạn chưa cập nhật địa chỉ này!"),
                  );
                }
              }),
        ),
      ],
    );
  }
}
