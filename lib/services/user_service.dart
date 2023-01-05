import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_paa/models/user_model.dart';
import 'package:tugas_paa/provider/state_provide.dart';
import 'package:tugas_paa/provider/user_provider.dart';

import '../routes/routes.dart';
import 'db_service.dart';

class UserService {
  final Dio _dio = Dio();
  final root = "https://golang-paa1.herokuapp.com/api/v1";
  Future<void> register({
    String? username,
    String? email,
    String? password,
    BuildContext? context,
  }) async {
    const profile = "https://firebasestorage.googleapis.com/v0/b/mawut-78582.appspot.com/o/profile.png?alt=media&token=bceb5a04-6539-4b32-8bcb-ecf34b5bf93c";
    final state = Provider.of<MyState>(context!, listen: false);
    try {
      final url = root + "/auth/register";
      final postData = {
        "username": username,
        "email": email,
        "password": password,
        "image": profile,
      };

      final response = await _dio.post(
        url,
        data: postData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        state.setMyState = StateCondition.done;
        Navigator.pop(context);
        FocusManager.instance.primaryFocus?.unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.data["message"],
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        state.setIsLogin = true;
        return;
      }
    } on DioError catch (e) {
      state.setMyState = StateCondition.done;
      Navigator.pop(context);
      FocusManager.instance.primaryFocus?.unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.response?.data["message"],
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }

  Future<void> login({
    String? email,
    String? password,
    BuildContext? context,
  }) async {
    final state = Provider.of<MyState>(context!, listen: false);
    final user = Provider.of<UserProvier>(context, listen: false);
    try {
      final url = root + "/auth/login";
      final postData = {
        "email": email,
        "password": password,
      };

      final response = await _dio.post(
        url,
        data: postData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
      final pref = await SharedPreferences.getInstance();
      if (response.statusCode == 200) {
        user.setRespone = UserModel.fromJson(response.data["data"]);
        await UserDB.insertData(
          UserModel.fromJson(response.data["data"]),
        );
        user.setToken = response.data["token"].toString();
        pref.setString("token", response.data["token"].toString());
        state.setMyState = StateCondition.done;
        Navigator.pop(context);
        FocusManager.instance.primaryFocus?.unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.data["message"],
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(
          context,
          Routes.main,
        );
        return;
      }
    } on DioError catch (e) {
      state.setMyState = StateCondition.done;
      Navigator.pop(context);
      FocusManager.instance.primaryFocus?.unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.response?.data["message"],
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }

  Future<void> getUser({
    BuildContext? context,
  }) async {
    final user = Provider.of<UserProvier>(context!, listen: false);
    final url = root + "/user";
    final pref = await SharedPreferences.getInstance();
    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": pref.getString("token"),
          },
        ),
      );

      if (response.statusCode == 200) {
        UserDB.updateData(UserModel.fromJson(response.data["data"]));
        final data = (await UserDB.getData(
            UserModel.fromJson(response.data["data"]).id));
        user.setRespone = data;
        user.setToken = pref.getString("token").toString();
        log("Server update: " + response.data["data"]["update_at"]);
        log("Server create: " + response.data["data"]["create_at"]);
        log("Client update: " + data.updateAt);
        log("Client create: " + data.createAt);
        return;
      }
    } on DioError catch (e) {
      Navigator.pop(context);
      FocusManager.instance.primaryFocus?.unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.response?.data["message"],
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }

  Future<void> update({
    String? username,
    String? email,
    BuildContext? context,
    String? token,
    String? image,
  }) async {
    final state = Provider.of<MyState>(context!, listen: false);
    final user = Provider.of<UserProvier>(context, listen: false);
    try {
      final url = root + "/user";
      final postData = {
        "username": username,
        "email": email,
        "image": image,
      };

      final response = await _dio.put(
        url,
        data: postData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": token,
          },
        ),
      );
      final pref = await SharedPreferences.getInstance();
      if (response.statusCode == 200) {
        UserDB.updateData(UserModel.fromJson(response.data["data"]));
        final data = (await UserDB.getData(
            UserModel.fromJson(response.data["data"]).id));
        user.setRespone = data;
        log("Server: " + response.data["data"]["update_at"]);
        log("Client: " + data.updateAt);
        user.setToken = response.data["token"].toString();
        pref.setString("token", response.data["token"].toString());
        state.setMyState = StateCondition.done;
        Navigator.pop(context);
        FocusManager.instance.primaryFocus?.unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.data["message"],
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        return;
      }
    } on DioError catch (e) {
      state.setMyState = StateCondition.done;
      Navigator.pop(context);
      FocusManager.instance.primaryFocus?.unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.response?.data["message"],
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }
}
