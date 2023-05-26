import 'package:app_food_2023/controller/admincontrollers/order_details.dart';
import 'package:app_food_2023/model/deliver_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/message.dart';

class DeliveryPersonDialog extends StatefulWidget {
  final List<DeliverModel> deliveryPersons;

  const DeliveryPersonDialog({Key? key, required this.deliveryPersons})
      : super(key: key);

  @override
  _DeliveryPersonDialogState createState() => _DeliveryPersonDialogState();
}

class _DeliveryPersonDialogState extends State<DeliveryPersonDialog> {
  final controller = Get.find<OrderDetailsController>();
  DeliverModel? selectedDeliveryPerson;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text(
          'CHỌN NHÂN VIÊN',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (DeliverModel deliveryPerson in widget.deliveryPersons)
              ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(deliveryPerson.Avatar.toString()),
                ),
                title: Text(deliveryPerson.FirstName.toString()),
                subtitle: Text(deliveryPerson.PhoneNumber.toString()),
                trailing: deliveryPerson.isSelected
                    ? Icon(Icons.check_box, color: Colors.green)
                    : null,
                onTap: () {
                  setState(() {
                    widget.deliveryPersons.forEach((person) {
                      person.isSelected = false;
                    });
                    deliveryPerson.isSelected = true;
                    selectedDeliveryPerson = deliveryPerson;
                  });
                },
              ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (selectedDeliveryPerson == null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ChoseNothingDialog();
                  },
                );
              } else {
                controller.choseDeliver(context, selectedDeliveryPerson!);
              }
            },
            child: Text('Chọn '),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
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
                  Color.fromARGB(255, 255, 46, 46)),
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
      ),
    );
  }
}

class ChoseNothingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Chú ý',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      content: Text(
        'Bạn chưa chọn nhân viên...',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Đóng'),
        ),
      ],
    );
  }
}
