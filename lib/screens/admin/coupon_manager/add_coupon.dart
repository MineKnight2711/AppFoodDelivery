import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddCouponPage extends StatefulWidget {
  @override
  _AddCouponPageState createState() => _AddCouponPageState();
}

class _AddCouponPageState extends State<AddCouponPage> {
  final _formKey = GlobalKey<FormState>();
  late String _code;
  late String _description;
  late dynamic _amount;
  bool _isPercent = false;
  late DateTime _expirationDate;

  @override
  void initState() {
    super.initState();
    _expirationDate = DateTime.now().add(Duration(days: 7));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Coupon'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Code'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a code';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _code = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _description = value;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Amount',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an amount';
                          }
                          if (!isNumeric(value)) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _amount = double.parse(value);
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    DropdownButton<bool>(
                      value: _isPercent,
                      onChanged: (value) {
                        setState(() {
                          _isPercent = value!;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: false,
                          child: Text('\$'),
                        ),
                        DropdownMenuItem(
                          value: true,
                          child: Text('%'),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Expiration date',
                        ),
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              _expirationDate = selectedDate;
                            });
                          }
                        },
                        readOnly: true,
                        validator: (value) {
                          if (_expirationDate == null) {
                            return 'Please select an expiration date';
                          }
                          if (_expirationDate.isBefore(DateTime.now())) {
                            return 'Expiration date must be in the future';
                          }
                          return null;
                        },
                        controller: TextEditingController(
                          text: _expirationDate == null
                              ? ''
                              : DateFormat.yMd().format(_expirationDate),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        _addCoupon();
                      },
                      child: Text('Add Coupon'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addCoupon() async {
    if (_formKey.currentState!.validate()) {
      try {
        FirebaseFirestore.instance.collection('coupons').add({
          'code': _code,
          'description': _description,
          'amount': _amount,
          'isPercent': _isPercent,
          'expirationDate': _expirationDate,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Coupon added successfully'),
          ),
        );
        Navigator.of(context).pop();
      } catch (error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred, please try again.'),
          ),
        );
      }
    }
  }

  bool isNumeric(String value) {
    return double.tryParse(value) != null;
  }
}
