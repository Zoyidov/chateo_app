import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Text('No internet'),
        ),
      ),
    );
  }
}
