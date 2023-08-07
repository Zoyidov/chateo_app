import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class Helper {
  Dio dio = Dio();
  static final Helper instance = Helper._();
  factory Helper() => instance;
  Helper._();

  final _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> getUrlImage({required String imageName}) async {
    final imageUrl =
        await _storage.ref('images/').child(imageName).getDownloadURL();
    return imageUrl;
  }

  Future<XFile?> pickImage({required bool fromCamera}) async {
    final XFile? file;
    if (fromCamera) {
      file = await _imagePicker.pickImage(source: ImageSource.camera);
    } else {
      file = await _imagePicker.pickImage(source: ImageSource.gallery);
    }
    return file;
  }

  Future uploadImage({
    required String filePath,
    required String fileName,
  }) async {
    File file = File(filePath);
    try {
      await _storage.ref('images/$fileName').putFile(file);
    } on FirebaseException catch (e) {
      log(e.message.toString());
    }
  }

  Future<void> saveFileToDownloadFolder(
      String imageUrl, BuildContext context) async {
    Response response = await dio.get(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
      onReceiveProgress: (count, total) => log(count.toString()),
    );
    final file = File(
        '/storage/emulated/0/Download/uzchat_image_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(response.data).then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image has been saved to download folder'),
            ),
          ),
        );
  }

  Future<void> signWithGoogle() async {
    GoogleSignInAccount? _user;
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return;
    }
    _user = googleUser;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
  }
}
