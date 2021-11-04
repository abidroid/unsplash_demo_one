import 'package:flutter/material.dart';
import 'package:unsplash_demo_one/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark ,
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
