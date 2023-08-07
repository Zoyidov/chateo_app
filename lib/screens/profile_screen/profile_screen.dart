import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen_homework/screens/profile_screen/widgets/edit_fields.dart';
import 'package:login_screen_homework/screens/profile_screen/widgets/user_info_frame.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../data/api_service.dart';
import '../../data/helper.dart';
import '../../utils/style/style.dart';
import '../../widgets/global_buttons.dart';
import '../auth_screen/sign_in_screen.dart';
import '../connection.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  User user = FirebaseAuth.instance.currentUser!;
  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (snapshot.data == ConnectivityResult.none) {
          return NoInternetScreen();
        }
        return Scaffold(
          appBar: AppBar(
            elevation: 10,
            centerTitle: true,
            title: Text(
              "Profile",
              style: UzchatStyle.w600,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ZoomTapAnimation(
                  onTap: () {
                    showLogoutConfirmation(context);
                  },
                  child: Icon(Icons.logout, color: Colors.red),
                ),
              ),
            ],

          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    var pickedImage =
                        await Helper.instance.pickImage(fromCamera: false);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Profile photo is updating!')));
                    await Helper.instance.uploadImage(
                      filePath: pickedImage!.path,
                      fileName: user.displayName!,
                    );
                    var imageUrl = await Helper.instance
                        .getUrlImage(imageName: user.displayName!);
                    await user.updatePhotoURL(imageUrl);
                    user = FirebaseAuth.instance.currentUser!;
                    await apiService.updateUserImage(
                        docId: user.uid, image: imageUrl);
                    setState(() {});
                  },
                  child: UserInfoFrame(
                    user: user,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                EditFields(
                  icon: Icons.edit,
                  text: 'Edit your name',
                  controller: nameController,
                ),
                Spacer(),
                GlobalButton(
                  buttonText: "Update",
                  color: Colors.teal,
                  onTap: () async {
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Your name is empty')));
                      return;
                    }
                    await user.updateDisplayName(nameController.text);
                    user = FirebaseAuth.instance.currentUser!;
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 50.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}




 showLogoutConfirmation(BuildContext context) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        title: Text('Confirm Logout'),
        message: Text('Are you sure you want to log out?'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              // Perform logout actions here
              await Helper.instance.signOutGoogle();
              await FirebaseAuth.instance.signOut().then(
                    (value) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(),
                  ),
                      (route) => false,
                ),
              );
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Logout', style: TextStyle(color: CupertinoColors.destructiveRed)),
          ),
        ],
      );
    },
  );
}
