import 'package:flutter/material.dart';

class RatingTest extends StatefulWidget {
  const RatingTest({super.key});

  @override
  State<RatingTest> createState() => _RatingTestState();
}

class _RatingTestState extends State<RatingTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ShowRatingBar(
        rating: 4.6,
        ratingCount: 12,
      )),
    );
  }
}

// ignore: must_be_immutable
class ShowRatingBar extends StatelessWidget {
  final double rating;
  final double size;
  int? ratingCount;
  ShowRatingBar({required this.rating, this.ratingCount, this.size = 50});

  @override
  Widget build(BuildContext context) {
    List<Widget> starlist = [];
    int realNumber = rating.floor(); //2.55->2
    int partNumber = ((rating - realNumber) * 10).ceil(); //Số phẩy

    for (int i = 0; i < 5; i++) {
      if (i < realNumber) {
        starlist.add(Icon(
          Icons.star,
          color: Colors.amber,
          size: size,
        ));
      } else if (i == realNumber) {
        starlist.add(SizedBox(
          height: size,
          width: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
                size: size,
              ),
              ClipRect(
                clipper: Clipper(part: partNumber),
                child: Icon(
                  Icons.star,
                  color: Colors.grey,
                  size: size,
                ),
              ),
            ],
          ),
        ));
      } else {
        starlist.add(Icon(
          Icons.star,
          color: Colors.grey,
          size: size,
        ));
      }
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: starlist,
    );
  }
}

class Clipper extends CustomClipper<Rect> {
  final int part;
  Clipper({required this.part});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
        (size.width / 10) * part, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return oldClipper != this;
  }
}
