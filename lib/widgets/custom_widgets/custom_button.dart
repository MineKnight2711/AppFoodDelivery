import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    required this.press,
    this.enabled = true,
  }) : super(key: key);
  final String text;
  final VoidCallback press;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Color(0xFF39C5C8),
        ),
        onPressed: enabled ? press : null,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}

class StyledGradienButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final String? buttonIconAssets;
  const StyledGradienButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.buttonIconAssets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        gradient: const LinearGradient(
          begin: Alignment(-0.95, 0.0),
          end: Alignment(1.0, 0.0),
          colors: [Color(0xff667eea), Color.fromARGB(255, 255, 100, 234)],
          stops: [0.0, 1.0],
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledForegroundColor: Colors.transparent.withOpacity(0.38),
          disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            buttonIconAssets != null
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      buttonIconAssets!,
                      scale: 2,
                    ),
                  )
                : const SizedBox.shrink(),
            SizedBox(
              width: size.width / 5,
            ),
            Text(
              buttonText,
              style: GoogleFonts.nunito(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
