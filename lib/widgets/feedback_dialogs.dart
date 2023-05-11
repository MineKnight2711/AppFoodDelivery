import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductRatingDialog extends StatefulWidget {
  final String productName, productID;

  ProductRatingDialog({required this.productName, required this.productID});

  @override
  _ProductRatingDialogState createState() => _ProductRatingDialogState();
}

class _ProductRatingDialogState extends State<ProductRatingDialog> {
  User? user = FirebaseAuth.instance.currentUser;
  double halfRating = 5.0;

  TextEditingController _feedbackController = new TextEditingController();

  void initSate() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Align(
        alignment: Alignment.center,
        child: Text('Đánh giá ${widget.productName}'),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bạn có hài lòng về món này không?'),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 10),
              Expanded(
                child: RatingBar.builder(
                  initialRating: 5,
                  minRating: 1,
                  allowHalfRating: true,
                  unratedColor: Colors.grey,
                  itemCount: 5,
                  itemSize: 30.0,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  updateOnDrag: true,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (ratingvalue) {
                    setState(() {
                      halfRating = ratingvalue;
                    });
                  },
                ),
              ),
              Text('${halfRating}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 25,
          ),
          SizedBox(
            width: 260,
            height: 50,
            child: TextFormField(
              controller: _feedbackController,
              decoration: InputDecoration(
                labelText: 'Nhận xét',
                hintText: 'Cảm nhận của bạn',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: TextStyle(fontSize: 16),
              cursorColor: Colors.blue,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('huỷ'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Gửi'),
          onPressed: () async {
            await FirebaseFirestore.instance.collection('ratings').add({
              'DishID': widget.productID,
              'UserID': user?.uid,
              'DateRecored': DateTime.now(),
              'Feedback': _feedbackController.text,
              'Score': halfRating,
            });

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
