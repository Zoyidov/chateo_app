import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../utils/colors/colors.dart';
import '../../utils/constanst/constants.dart';
import '../../utils/icons/icons.dart';
import '../../utils/style/style.dart';
import '../../widgets/global_buttons.dart';
import '../connection.dart';
import '../profile_screen/profile_screen.dart';

class SelectChatScreen extends StatelessWidget {
  const SelectChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (ConnectivityResult.none == snapshot.data) {
          return NoInternetScreen();
        } else {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  UzchatIcons.message,
                  width: 150.0,
                  height: 150.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('Welcome to Chateo',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 30),),
                SizedBox(
                  height: 15.0,
                ),
                GlobalButton(
                  buttonText: "Users",
                  color: Colors.green.withOpacity(0.4),
                  onTap: () {
                    Navigator.pushNamed(context, Constants.uzchatUsersScreen);
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                GlobalButton(
                  buttonText: "Group",
                  color: Colors.green.withOpacity(0.4),
                  onTap: () {
                    Navigator.pushNamed(context, Constants.groupChatScreen);
                  },
                ),
                SizedBox(
                  height: 50.0,
                ),
                GlobalButton(
                  buttonText: "Log out",
                  color: Colors.red,
                  onTap: () {
                    showLogoutConfirmation(context);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
