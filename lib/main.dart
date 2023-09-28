import 'package:flutter/material.dart';
import 'package:full/home.dart';
import 'package:full/nav.dart';
import 'package:full/signin.dart';
import 'package:full/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:full/wish.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: navbar(),
      routes: {
        "/home":(context) => home(),
        "/signup":(context) => Signup(),
        "/signin":(context) => Signin(),
        "/nav":(context) => navbar(),
      },
    );
  }
}
