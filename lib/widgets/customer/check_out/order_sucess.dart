import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../appstyle/screensize_aspectratio/mediaquery.dart';
import '../../../model/dishes_model.dart';

Widget showInsufficientQuantityWidget(
    BuildContext context, List<DishModel>? dishes) {
  return AlertDialog(
    title: Center(child: Text('Số lượng không hợp lệ')),
    content: Container(
      height: MediaHeight(context, 3),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('Các món bạn chọn đã hết hàng:'),
            SizedBox(height: 16),
            if (dishes != null) ...[
              for (final dish in dishes) ...[
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        dish.Image != null
                            ? CircleAvatar(
                                radius: 23,
                                backgroundImage: Image.network(
                                  dish.Image!,
                                ).image,
                              )
                            : Image.asset('images\diet.png'),
                        Column(
                          children: [
                            Text(
                              '${dish.Name}',
                              textAlign: TextAlign.center,
                            ),
                            Center(
                              child: Text.rich(
                                TextSpan(
                                  text: 'Còn lại ',
                                  children: [
                                    TextSpan(
                                      text: '${dish.Quantity}',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                    TextSpan(text: ' phần !'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   w
                    //   height: MediaHeight(context, 40),
                    // ),
                    // Center(child: Text('Còn lại: ${dish.Quantity} phần')),
                    SizedBox(
                      height: MediaHeight(context, 25),
                    ),
                  ],
                )
              ]
            ]
          ],
        ),
      ),
    ),
    actions: [
      Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.orange,
        ),
        child: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "OK",
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ],
  );
}

class OrderSuccesDialog extends StatelessWidget {
  final String imagePath;
  final String message;
  final String buttonText;
  final Function()? onButtonPressed;

  const OrderSuccesDialog({
    Key? key,
    required this.imagePath,
    required this.message,
    required this.buttonText,
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, height: 100, width: 100),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.orange,
              ),
              child: TextButton(
                onPressed: onButtonPressed ?? () => Navigator.pop(context),
                child: Text(
                  buttonText,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
