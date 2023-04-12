import 'package:flutter/material.dart';
import 'package:pennyplanner/firebase_options.dart';
import 'pages/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pennyplanner/pages/home_page.dart';
import 'package:pennyplanner/pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //käynnistetään firebase applikaatiossa
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: const HomePage(), //MUISTA VAIHTAA TAKAISIN WELCOMEEN
    );
  }
}
