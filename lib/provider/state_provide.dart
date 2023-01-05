import 'package:flutter/material.dart';

enum StateCondition {loading, done}

class MyState with ChangeNotifier {
  StateCondition? _state;

  set setMyState(StateCondition val) => _state = val;

  StateCondition get getMyState => _state!;

  bool isLogin = true;
  bool isVisibleLogin = false;

  set setIsLogin(bool val) {
    isLogin = val;
    notifyListeners();
  }
  set setIsVisibleLogin(bool val) {
    isVisibleLogin = val;
    notifyListeners();
  }
}