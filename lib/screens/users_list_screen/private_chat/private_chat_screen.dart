import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/api_service.dart';
import '../../../data/helper.dart';
import '../../../utils/style/style.dart';
import '../../chateo_group/widgets/message_text_item.dart';
import '../../chateo_group/widgets/send_field.dart';
import '../../connection.dart';

class PrivateChatScreen extends StatelessWidget {
  PrivateChatScreen({
    super.key,
    required this.collectionName,
  });

  final String collectionName;

  final TextEditingController textController = TextEditingController();

  final ScrollController scrollController = ScrollController();
  final User user = FirebaseAuth.instance.currentUser!;
  final ApiService apiService = ApiService();
  final TextEditingController imageTextController = TextEditingController();
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (ConnectivityResult.none == snapshot.data) {
          return NoInternetScreen();
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Chateo",
              style: UzchatStyle.w600,
            ),
          ),
          body: StreamBuilder(
            stream: apiService.getPrivateChat(collectionName),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const LinearProgressIndicator();
              var currentUser = FirebaseAuth.instance.currentUser!;
              var data = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: scrollController,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          scrollController.jumpTo(
                              scrollController.position.maxScrollExtent);
                        });
                        return MessegeItem(
                          messages: data,
                          index: index,
                          isMe: data[index].id == currentUser.uid,
                          user: user,
                        );
                      },
                    ),
                  ),
                  SendField(
                    textController: textController,
                    onTap: () {
                      if (textController.text.isEmpty) return;
                      scrollController
                          .jumpTo(scrollController.position.maxScrollExtent);
                      var sms = textController.text;
                      textController.clear();
                      apiService
                          .addMessageToPrivate(
                            collectionName: collectionName,
                            uid: currentUser.uid,
                            message: sms,
                            name: currentUser.displayName!,
                            imageUrl: '',
                            profilePhoto: currentUser.photoURL ?? ' ',
                          )
                          .then(
                            (value) => scrollController.jumpTo(
                                scrollController.position.maxScrollExtent),
                          );
                    },
                    imagePicker: () async {
                      await selectPhotoDialog(context);
                    },
                  ),
                ],
              );
            },
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
                        .addMessageToPrivate(
                            uid: FirebaseAuth.instance.currentUser!.uid,
                            message: imageTextController.text,
                            name: user.displayName!,
                            imageUrl: imageUrl,
                            profilePhoto: user.photoURL ?? '',
                            collectionName: collectionName)
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
