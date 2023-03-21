import 'package:flutter/material.dart';
import 'package:pennyplanner/pages/settings_page.dart';
import 'pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penny Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomePage(), //MUISTA VAIHTAA TAKAISIN WELCOMEEN
    );
  }
}
