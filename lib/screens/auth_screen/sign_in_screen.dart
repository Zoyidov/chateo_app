import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_screen_homework/screens/auth_screen/widgets/auth_buttons.dart';
import 'package:login_screen_homework/screens/auth_screen/widgets/sign_google_button.dart';
import 'package:lottie/lottie.dart';
import '../../data/api_service.dart';
import '../../utils/colors/colors.dart';
import '../../utils/constanst/constants.dart';
import '../../utils/icons/icons.dart';
import '../../utils/style/style.dart';
import '../../widgets/global_buttons.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final ApiService apiService = ApiService();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text("Sign in", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30.0,
            ),
            Lottie.asset(
              UzchatIcons.sign,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Welcome Back to Chateo",
                style: UzchatStyle.w500.copyWith(
                  fontSize: 30.0,
                  color: Colors.green.
                  withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            AuthFields(
              controller: emailController,
              hintText: 'Email', keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, prefixIcon: Icons.email, caption: '',
            ),
            SizedBox(height: 10),
            AuthFields(
              controller: passWordController,
              hintText: 'Password', keyboardType: TextInputType.visiblePassword, textInputAction: TextInputAction.done, prefixIcon: Icons.key, caption: '',
            ),
            SizedBox(
              height: 10.0,
            ),
            GlobalButton(
              buttonText: 'Sign In',
              color: Colors.green.
              withOpacity(0.4),
              onTap: () async {
                await signIn(
                  email: emailController.text,
                  password: passWordController.text,
                  context: context,
                ).then(
                  (value) => Navigator.pushReplacementNamed(
                      context, Constants.selectChatScreen),
                );
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(
                  context, Constants.signUpScreen),
              child: Text("Don't have an account?",style: TextStyle(color: Colors.red),),
            ),
            SizedBox(
              height: 30.0,
            ),
            SignGoogleButton(apiService: apiService)
          ],
        ),
      ),
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
      throw Exception();
    }
  }
}
