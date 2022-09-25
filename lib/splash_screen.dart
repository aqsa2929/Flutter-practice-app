// Splash Screen
import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () async {
      SharedPreferences pref = await SharedPreferences.getInstance();

      var token = pref.getString('token');
      print("Token: $token");

      if (token == null || token == 'null') {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Login()));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const MyHomePage(title: "title")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: FlutterLogo(),
      ),
    );
  }
}
