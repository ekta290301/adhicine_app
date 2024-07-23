// import 'package:adhicine_app/auth_service.dart';
// import 'package:adhicine_app/home_page.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Splash_Screen extends StatefulWidget {
//   const Splash_Screen({Key? key}) : super(key: key);

//   @override
//   State<Splash_Screen> createState() => _Splash_ScreenState();
// }

// class _Splash_ScreenState extends State<Splash_Screen> {
//   final AuthService _authService = AuthService();

//   @override
//   void initState() {
//     super.initState();
//     _checkUserStatus();
//   }

//   Future<void> _checkUserStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     final bool userLoggedIn = prefs.getBool('userLoggedIn') ?? false;

//     if (userLoggedIn) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => Home_page()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     const splashDuration = Duration(seconds: 0);
//     return Scaffold(
//       appBar: AppBar(),
//     );
//   }
// }
