import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingBarScreen extends StatefulWidget {
  const RatingBarScreen({Key? key}) : super(key: key);

  @override
  State<RatingBarScreen> createState() => _RatingBarScreenState();
}

class _RatingBarScreenState extends State<RatingBarScreen> {
  double halfRating = 0;
  double emojiRating = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Flutter Rating Bar"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Half & Full Rating Bar',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24.0,
            ),
            textAlign: TextAlign.center,
          ),
          Center(
            child: RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              allowHalfRating: true,
              unratedColor: Colors.grey,
              itemCount: 5,
              itemSize: 50.0,
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
          const SizedBox(
            height: 20,
          ),
          Text(
            'Rating : $halfRating',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Emoji  Rating Bar',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24.0,
            ),
            textAlign: TextAlign.center,
          ),
          Center(
            child: RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              allowHalfRating: false,
              unratedColor: Colors.grey,
              itemCount: 5,
              itemSize: 50.0,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              updateOnDrag: true,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: emojiRating == 1 ? Colors.red : Colors.grey,
                    );
                  case 1:
                    return Icon(
                      Icons.sentiment_dissatisfied,
                      color: emojiRating == 2 ? Colors.redAccent : Colors.grey,
                    );
                  case 2:
                    return Icon(
                      Icons.sentiment_neutral,
                      color: emojiRating == 3 ? Colors.amber : Colors.grey,
                    );
                  case 3:
                    return Icon(
                      Icons.sentiment_satisfied,
                      color: emojiRating == 4 ? Colors.lightGreen : Colors.grey,
                    );
                  case 4:
                    return Icon(
                      Icons.sentiment_very_satisfied,
                      color: emojiRating == 5 ? Colors.green : Colors.grey,
                    );
                  default:
                    return Container();
                }
              },
              onRatingUpdate: (ratingvalue) {
                setState(() {
                  emojiRating = ratingvalue;
                });
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            emojiRating == 1
                ? "SICK"
                : emojiRating == 2
                    ? "BAD"
                    : emojiRating == 3
                        ? "OKAY"
                        : emojiRating == 4
                            ? "GOOD"
                            : emojiRating == 5
                                ? "GREAT"
                                : "",
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '$average',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24.0,
            ),
            textAlign: TextAlign.center,
          ),
          Center(
            child: SizedBox(
              height: 50,
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  avarageRating();
                },
                child: Text("Tính"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double randomPoint = 0;
  double average = 0;
  avarageRating() {
    double randomDouble = (Random().nextInt(9) / 2) + 1;
    print(randomDouble);
    // double sum = 0;
    double randomCus = Random().nextInt(50) + 1;
    print(randomCus);
    // double randomNum = (Random().nextInt(41) + 10) / 10;
    // randomNum = (randomNum.round() * 2).toDouble() / 2;
    // setState(() {
    //   randomPoint = numbers;
    // });

    // print('Điểm trung bình của sản phẩm là: $randomNum');
    double sum = (randomCus * randomDouble);
    print(sum);
    average = sum / randomCus;
    setState(() {
      average = average;
    });

    // print('Điểm trung bình của sản phẩm là: $average');
  }
}
