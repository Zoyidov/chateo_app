import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../utils/colors/colors.dart';
import '../utils/style/style.dart';

class GlobalButton extends StatelessWidget {
  const GlobalButton({
    Key? key,
    required this.buttonText,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  final String buttonText;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: onTap,
      child: Container(
        height: 50.0,
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        width: double.infinity,
        child: Center(
          child: Text(
            buttonText,
            style: UzchatStyle.w600.copyWith(
              color: UzchatColors.colorWhite,
            ),
          ),
        ),
      ),
    );
  }
}
