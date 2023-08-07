class ChatModel {
  final String id;
  final String name;
  final String messages;
  final String date;
  final String imageUrl;
  final String profilePhoto;

  ChatModel({
    required this.id,
    required this.messages,
    required this.name,
    required this.date,
    required this.imageUrl,
    required this.profilePhoto,
  });

  factory ChatModel.fromJson(Map<String, Object?> json) {
    return ChatModel(
      id: json["id"] as String,
      messages: json["message"] as String,
      name: json["name"] as String,
      date: json["date"] as String,
      imageUrl: json["image"] as String,
      profilePhoto: json["profile_photo"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": messages,
        "name": name,
        "date": date,
        "image": imageUrl,
        "profile_photo": profilePhoto,
      };

  @override
  String toString() => "messages: $messages id: $id name: $name date: $date"
      "imageUrl $imageUrl";
}
