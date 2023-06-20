import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeliverySelectionDialog extends StatefulWidget {
  @override
  _DeliverySelectionDialogState createState() =>
      _DeliverySelectionDialogState();
}

class _DeliverySelectionDialogState extends State<DeliverySelectionDialog> {
  String selectedDeliveryPerson = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Text(
        'DATFOOD | SELECT DELIVERY',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      content: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getDeliveryPersons(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            List<Map<String, dynamic>> deliveryPersons = snapshot.data!;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (Map<String, dynamic> deliveryPerson in deliveryPersons)
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(deliveryPerson['avatar']),
                    ),
                    title: Text(deliveryPerson['fullName']),
                    subtitle: Text(deliveryPerson['phoneNumber']),
                    onTap: () {
                      setState(() {
                        selectedDeliveryPerson = deliveryPerson['fullName'];
                      });
                    },
                  ),
              ],
            );
          } else {
            return Center(
              child: Text('No data'),
            );
          }
        },
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (selectedDeliveryPerson == '') {
              // Thông báo khi chưa chọn nhân viên giao hàng
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Vui lòng chọn nhân viên giao hàng'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Đóng'),
                      ),
                    ],
                  );
                },
              );
            } else {
              // Thông báo khi đã chọn nhân viên giao hàng
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                        'Đã chọn nhân viên giao hàng: $selectedDeliveryPerson'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Đóng'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Text('Chọn nhân viên'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.green,
            ),
            textStyle: MaterialStateProperty.all<TextStyle>(
              TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Đóng'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 255, 46, 46),
            ),
            textStyle: MaterialStateProperty.all<TextStyle>(
              TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<List<Map<String, dynamic>>> _getDeliveryPersons() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('Role', isEqualTo: 'Delivery')
        .get();

    List<Map<String, dynamic>> deliveryPersons = [];
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> deliveryPerson = {
        'avatar': doc['Avatar'],
        'fullName': doc['LastName'] + ' ' + doc['FirstName'],
        'phoneNumber': doc['PhoneNumber'],
      };
      deliveryPersons.add(deliveryPerson);
    });

    return deliveryPersons;
  }
}
