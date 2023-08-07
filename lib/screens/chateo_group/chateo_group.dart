import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen_homework/screens/chateo_group/widgets/message_text_item.dart';
import 'package:login_screen_homework/screens/chateo_group/widgets/send_field.dart';
import '../../data/api_service.dart';
import '../../data/helper.dart';
import '../../utils/colors/colors.dart';
import '../../utils/constanst/constants.dart';
import '../connection.dart';

class ChateoGroupScreen extends StatelessWidget {
  ChateoGroupScreen({super.key});

  final TextEditingController textController = TextEditingController();

  final TextEditingController imageTextController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  final ApiService apiService = ApiService();

  final User user = FirebaseAuth.instance.currentUser!;

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (ConnectivityResult.none == snapshot.data) return NoInternetScreen();
        return Scaffold(
          appBar: AppBar(
            elevation: 10,
            backgroundColor: Colors.black,
            title: const Text("Chateo",style: TextStyle(color: Colors.white),),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(
                  context, Constants.profileScreen),
              child: Icon(
                Icons.person,size:30,
                color: UzchatColors.colorWhite,
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StreamBuilder(
                stream: apiService.getGroupChats(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();
                  var messages = snapshot.data!;
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    scrollController
                        .jumpTo(scrollController.position.maxScrollExtent);
                  });
                  return Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return MessegeItem(
                          messages: messages,
                          index: index,
                          isMe: user.uid == messages[index].id,
                          user: user,
                        );
                      },
                    ),
                  );
                },
              ),
              SendField(
                textController: textController,
                onTap: () {
                  if (textController.text.isEmpty) return;
                  var message = textController.text;
                  textController.clear();
                  apiService
                      .addMessageToGroup(
                        uid: FirebaseAuth.instance.currentUser!.uid,
                        message: message,
                        name: user.displayName!,
                        imageUrl: '',
                        profilePhoto: user.photoURL ?? '',
                      )
                      .then(
                        (value) => scrollController
                            .jumpTo(scrollController.position.maxScrollExtent),
                      );
                },
                imagePicker: () async {
                  await selectPhotoDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }



  selectPhotoDialog(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () async {
                await sendPhotoDialog(context, true);
                Navigator.pop(context);
              },
              child: Text('Camera'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                await sendPhotoDialog(context, false);
                Navigator.pop(context);
              },
              child: Text('Select from Gallery'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text('Cancel',style: TextStyle(color: Colors.red),),
          ),
        );
      },
    );
  }


  Future<void> sendPhotoDialog(BuildContext context, bool fromCamera) async {
    var file = await Helper.instance.pickImage(fromCamera: fromCamera);
    var dialogImage = File(file!.path);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .2,
              width: MediaQuery.of(context).size.width * .3,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Image.file(
                    dialogImage,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            TextField(
              style: TextStyle(color: Colors.white),
              controller: imageTextController,
              maxLength: null,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Add a caption',
                suffixIcon: GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    await Helper.instance.uploadImage(
                      filePath: file.path,
                      fileName: file.name,
                    );
                    imageUrl =
                        await Helper.instance.getUrlImage(imageName: file.name);
                    apiService
                        .addMessageToGroup(
                            uid: FirebaseAuth.instance.currentUser!.uid,
                            message: imageTextController.text,
                            name: user.displayName!,
                            imageUrl: imageUrl,
                            profilePhoto: user.photoURL ?? '')
                        .then(
                          (value) => scrollController.jumpTo(
                              scrollController.position.maxScrollExtent),
                        );
                    imageTextController.clear();
                  },
                  child: Icon(Icons.send),
                ),
              ),
            )
          ],
        ),
      ),
    ).then((value) {
      Navigator.pop(context);
    });
  }
}
