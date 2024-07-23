import 'package:adhicine_app/AddMedicinePage.dart';
import 'package:adhicine_app/home_page.dart';
import 'package:adhicine_app/sign-up.dart';
import 'package:adhicine_app/userProfile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDXUvlCAU0jJdFxY-t9x-2IvqF6iEwiqs4",
          appId: "1:693499513606:android:74c551a8f5b381c91fac87",
          messagingSenderId: "693499513606",
          projectId: "flutterdemo-c5dfb"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: 'sign_up_page',
      routes: {
        //'splash_screen': (context) => Splash_Screen(),
        'sign_up_page': (context) => Sign_Up_Page(),
        'home_page': (context) => Home_page(),
        'addMedicinePage': (context) => AddMedicinePage(),
        'userProfilePage ': (context) => UserProfilePage(),

        // home: Sign_Up_Page(),
      },
      home: Sign_Up_Page(),
    );
  }
}
