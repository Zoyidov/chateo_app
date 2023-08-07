import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_model.dart';
import '../models/users_model.dart';

class ApiService {
  final CollectionReference collectionChat =
      FirebaseFirestore.instance.collection("chats");
  final CollectionReference collectionUsers =
      FirebaseFirestore.instance.collection("Users");

  Stream<List<ChatModel>> getGroupChats() {
    return collectionChat.orderBy("date", descending: false).snapshots().map(
          (event) => event.docs
              .map((e) => ChatModel.fromJson(e.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  /// It checks if a collection is empty or not
  ///
  /// Args:
  ///   collection (String): The name of the collection you want to check.
  ///
  /// Returns:
  ///   A Future<bool>
  Future<bool> check(String collection) async {
    var data = await FirebaseFirestore.instance.collection(collection).get();
    if (data.docs.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future addMessageToGroup({
    required String uid,
    required String message,
    required String name,
    required String imageUrl,
    required String profilePhoto,
  }) async {
    await collectionChat.add({
      "id": uid,
      "message": message,
      "name": name,
      "image": imageUrl,
      "profile_photo": profilePhoto,
      "date": DateTime.now().toString()
    });
  }

  Stream<List<UsersModel>> getUsers(String id) {
    return collectionUsers.where("id", isNotEqualTo: id).snapshots().map(
        (event) => event.docs
            .map((e) => UsersModel.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addUser({required String name, required String uid}) async {
    await collectionUsers.doc(uid).set({
      "id": uid,
      "name": name,
      "image": '',
    });
  }

  Future<void> updateUserImage({
    required String docId,
    required String image,
  }) async {
    await collectionUsers.doc(docId).update({
      "image": image,
    });
  }

  /// It returns a stream of a list of ChatModel objects, which are ordered by date, and are mapped from
  /// a snapshot of a collection of documents
  ///
  /// Args:
  ///   collectionName (String): The name of the collection you want to get the data from.
  ///
  /// Returns:
  ///   A Stream of a List of ChatModel objects.
  Stream<List<ChatModel>> getPrivateChat(String collectionName) {
    CollectionReference privateChatCollections =
        FirebaseFirestore.instance.collection(collectionName);
    return privateChatCollections
        .orderBy("date", descending: false)
        .snapshots()
        .map((event) => event.docs
            .map((e) => ChatModel.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }

  Future addMessageToPrivate({
    required String collectionName,
    required String uid,
    required String message,
    required String name,
    required String imageUrl,
    required String profilePhoto,
  }) async {
    FirebaseFirestore.instance.collection(collectionName).add({
      "id": uid,
      "message": message,
      "name": name,
      "image": imageUrl,
      "profile_photo": '',
      "date": DateTime.now().toString()
    });
  }

  void editPrivateMessage(String message, String collectionName, String docId) {
    FirebaseFirestore.instance.collection(collectionName).doc(docId).update({
      'message': message,
    });
  }

  void editGroupMessage(String message, String docId) {
    FirebaseFirestore.instance.collection('chats').doc(docId).update({
      'message': message,
    });
  }
}
