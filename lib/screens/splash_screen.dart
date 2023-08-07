import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_screen_homework/utils/icons/icons.dart';
import 'package:lottie/lottie.dart';

import '../utils/constanst/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 3), () {
      if (user == null) {
        Navigator.pushReplacementNamed(context, Constants.signUpScreen);
      } else {
        Navigator.pushReplacementNamed(context, Constants.selectChatScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: LottieBuilder.asset(
          UzchatIcons.splash,
        ),
      ),
    );
  }
}
