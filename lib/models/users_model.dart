class UsersModel {
  final String name;
  final String id;
  final String image;
  UsersModel({
    required this.id,
    required this.name,
    required this.image,
  });
  factory UsersModel.fromJson(Map<String, dynamic> json) =>
      UsersModel(id: json["id"], name: json["name"], image: json["image"]);
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}
