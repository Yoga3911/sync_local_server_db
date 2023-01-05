import 'package:flutter/material.dart';
import 'package:tugas_paa/services/user_service.dart';
import 'package:tugas_paa/views/home.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: UserService().getUser(
          context: context,
        ),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF9d39ff),
              ),
            );
          }
          return const HomePage();
        },
      ),
    );
  }
}
