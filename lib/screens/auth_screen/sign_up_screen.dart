import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_screen_homework/screens/auth_screen/widgets/auth_buttons.dart';
import 'package:login_screen_homework/screens/auth_screen/widgets/sign_google_button.dart';
import 'package:lottie/lottie.dart';
import '../../data/api_service.dart';
import '../../utils/constanst/constants.dart';
import '../../utils/icons/icons.dart';
import '../../utils/style/style.dart';
import '../../widgets/global_buttons.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final ApiService apiService = ApiService();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Sign Up", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50.0,
            ),
            Lottie.asset(
              UzchatIcons.sign,
              height: 200,
            ),
            SizedBox(
              height: 20.0,
            ),
            AuthFields(
              controller: nameController,
              hintText: 'Name', keyboardType: TextInputType.name, textInputAction: TextInputAction.next, prefixIcon: Icons.person, caption: '',
            ),
            SizedBox(
              height: 10.0,
            ),
            AuthFields(
              controller: emailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, prefixIcon: Icons.email, caption: '',
            ),
            SizedBox(
              height: 10.0,
            ),
            AuthFields(
              controller: passWordController,
              hintText: 'Password',
              keyboardType: TextInputType.visiblePassword, textInputAction: TextInputAction.done, prefixIcon: Icons.key, caption: '',
            ),
            SizedBox(
              height: 30.0,
            ),
            GlobalButton(
              buttonText: 'Sign Up',
              color: Colors.green.
              withOpacity(0.4),
              onTap: () async {
                if (nameController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    passWordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }
                var s = await signUp(
                  email: emailController.text,
                  password: passWordController.text,
                  name: nameController.text,
                  context: context,
                ).then(
                  (value) => Navigator.pushReplacementNamed(
                      context, Constants.selectChatScreen),
                );
                print(s.toString());
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(
                  context, Constants.signInScreen),
              child: Text("Do you have already an account?"),
            ),
            SignGoogleButton(
              apiService: apiService,
            )
          ],
        ),
      ),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    ApiService apiService = ApiService();
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await apiService.addUser(
        name: name,
        uid: FirebaseAuth.instance.currentUser!.uid,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
      throw Exception();
    }
  }
}
