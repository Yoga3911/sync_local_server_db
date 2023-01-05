import 'package:flutter/material.dart';
import 'package:tugas_paa/views/main_init.dart';

import '../views/auth.dart';
import '../views/home.dart';

class Routes {
  static const main = "/main";
  static const home = "/home";
  static const auth = "/auth";

  static final data = <String, WidgetBuilder>{
    main: (context) => const MainPage(),
    home: (context) => const HomePage(),
    auth: (context) => const AuthPage(),
  };
}
