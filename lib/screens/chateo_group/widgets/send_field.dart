import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../../utils/colors/colors.dart';

class SendField extends StatelessWidget {
  const SendField({
    Key? key,
    required this.textController,
    required this.onTap,
    required this.imagePicker,
  }) : super(key: key);

  final TextEditingController textController;
  final VoidCallback onTap;
  final VoidCallback imagePicker;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          color: Colors.black,
          child: TextField(
            maxLines: null,
            style: TextStyle(color: Colors.white),
            controller: textController,
            cursorColor: UzchatColors.colorWhite,
            decoration: InputDecoration(
              prefixIcon: ZoomTapAnimation(
                onTap: imagePicker,
                child: Icon(
                  Icons.insert_link,
                  size: 30,
                  color: UzchatColors.colorWhite,
                ),
              ),
              suffixIcon: GestureDetector(
                onTap: onTap,
                child: Icon(Icons.send, color: UzchatColors.colorWhite),
              ),
              hintText: "Message",
              hintStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
