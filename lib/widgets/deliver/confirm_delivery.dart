import 'package:flutter/material.dart';

class ConfirmDeliveryDialog extends StatelessWidget {
  final Function() onConfirm;

  const ConfirmDeliveryDialog({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Xác nhận'),
      content: Text('Bạn có chắc muốn hoàn thành đơn hàng này?'),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
      actions: [
        Container(
          width: double.infinity,
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.green),
                ),
              ),
            ),
            child: Text('Xác nhận'),
            onPressed: onConfirm,
          ),
        ),
        SizedBox(width: 8),
        Container(
          width: 100,
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.red),
                ),
              ),
            ),
            child: Text('Hủy'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
