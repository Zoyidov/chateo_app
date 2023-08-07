import 'package:flutter/material.dart';

class AuthFields extends StatefulWidget {
  final String hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final IconData prefixIcon;
  final String caption;
  final TextEditingController controller;

  const AuthFields({
    Key? key,
    required this.hintText,
    required this.keyboardType,
    required this.textInputAction,
    required this.prefixIcon,
    required this.caption,
    required this.controller,
  }) : super(key: key);

  @override
  _AuthFieldsState createState() => _AuthFieldsState();
}

class _AuthFieldsState extends State<AuthFields> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                widget.caption,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          SizedBox(
            height: 5,
          ),
          TextField(
            style: TextStyle(color: Colors.white),
            controller: widget.controller,
            decoration: InputDecoration(
// contentPadding: EdgeInsets.only(left: 16,top: 12,right: 20,bottom: 60),
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(
                widget.prefixIcon,
                color: Colors.white,
              ),
              suffixIcon: widget.keyboardType == TextInputType.visiblePassword
                  ? IconButton(
                      splashRadius: 1,
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(30),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(30),
              ),
// filled: true,
// fillColor: Colors.black12,
            ),
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.keyboardType == TextInputType.visiblePassword
                ? !_isPasswordVisible
                : false,
          ),
        ],
      ),
    );
  }
}
