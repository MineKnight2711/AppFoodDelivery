import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  final String networkImageUrl;
  final double size;

  NetworkImageWidget({required this.networkImageUrl, this.size = 200.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          _showImageDialog(context);
        },
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: size / 2,
            child: ClipOval(
              child: Image.network(
                '$networkImageUrl',
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: size,
            height: size,
            child: Image.network(
              '$networkImageUrl',
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
