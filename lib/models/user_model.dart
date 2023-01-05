class UserModel {
    UserModel({
        required this.id,
        required this.username,
        required this.email,
        required this.password,
        required this.image,
        required this.createAt,
        required this.updateAt,
    });

    final int id;
    final String username;
    final String email;
    final String password;
    final String image;
    final String createAt;
    final String updateAt;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        image: json["image"],
        createAt: json["create_at"],
        updateAt: json["update_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
        "image": image,
        "create_at": createAt,
        "update_at": updateAt,
    };
}
