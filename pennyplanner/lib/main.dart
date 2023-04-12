import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pennyplanner/pages/home_page.dart';

void main() {
  runApp(const MyApp());
  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }
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
