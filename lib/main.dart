import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_paa/provider/init_provider.dart';
import 'package:tugas_paa/routes/routes.dart';

Future<void> selectRoute() async {
  final pref = await SharedPreferences.getInstance();
  if (pref.getString("token") != null) {
    runApp(
      const MyApp(route: Routes.main),
    );
    return;
  } else if (pref.getString("token") == null) {
    runApp(
      const MyApp(route: Routes.auth),
    );
    return;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  selectRoute();
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.route,
  }) : super(key: key);

  final String route;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: InitProvider.data,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: route,
        routes: Routes.data,
      ),
    );
  }
}
