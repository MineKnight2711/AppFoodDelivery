import 'package:flutter/material.dart';

class SimpleUserCard extends StatelessWidget {
  final ImageProvider userProfilePic;
  final String userName;
  final double? imageRadius;
  final Widget? userMoreInfo;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final Icon? icon;

  const SimpleUserCard({
    super.key,
    required this.userProfilePic,
    required this.userName,
    this.imageRadius = 10,
    this.userMoreInfo,
    this.onTap,
    this.textStyle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    double mediaQueryHeight = MediaQuery.of(context).size.height;
    double mediaQueryWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: mediaQueryWidth,
      height: mediaQueryHeight / 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: GestureDetector(
              onTap: (onTap == null) ? () {} : onTap,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(imageRadius!),
                    child: Image(
                      image: userProfilePic,
                      fit: BoxFit.cover,
                      height: mediaQueryHeight / 5,
                      width: mediaQueryWidth / 2.6,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: (icon != null)
                        ? icon!
                        : const Icon(
                            Icons.camera,
                            color: Colors.transparent,
                          ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3),
            child: Text(
              userName,
              style: (textStyle == null)
                  ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                  : textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
