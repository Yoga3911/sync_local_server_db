import 'package:flutter/cupertino.dart';
import 'package:tugas_paa/models/user_model.dart';
import 'package:tugas_paa/services/user_service.dart';

class UserProvier with ChangeNotifier {
  final UserService _userService = UserService();

  void register({
    String? username,
    String? email,
    String? password,
    BuildContext? context,
  }) {
    _userService.register(
      email: email,
      username: username,
      password: password,
      context: context,
    );
  }

  void login({
    String? email,
    String? password,
    BuildContext? context,
  }) {
    _userService.login(
      email: email,
      password: password,
      context: context,
    );
  }

  UserModel? _userModel;

  set setRespone(UserModel val) {
    _userModel = val;
    notifyListeners();
  }

  UserModel? get getResponse => _userModel;

  String? _token;

  set setToken(String val) => _token = val;

  String? get getToken => _token;
}
