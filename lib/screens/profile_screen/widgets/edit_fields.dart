import 'package:flutter/material.dart';

import '../../../utils/colors/colors.dart';

class EditFields extends StatelessWidget {
  const EditFields({
    Key? key,
    required this.text,
    required this.icon,
    required this.controller,
  }) : super(key: key);
  final String text;
  final IconData icon;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
        color: UzchatColors.colorWhite,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          suffixIcon: Icon(icon),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
