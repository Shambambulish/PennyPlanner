import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pennyplanner/firebase_options.dart';
import 'package:pennyplanner/utils/theme.dart';
import 'package:provider/provider.dart';
import 'pages/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pennyplanner/pages/home_page.dart';
import 'package:pennyplanner/pages/settings_page.dart';
import 'pages/splash_screen.dart';
import '../pages/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //käynnistetään firebase applikaatiossa
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(isDarkMode: false),
      child: const MyApp()));

  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: ["CF3967800E18D9F4B4B5FDAECECEC421"]);
  MobileAds.instance.updateRequestConfiguration(configuration);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => MaterialApp(
        title: 'Penny Planner',
        theme: themeProvider.getTheme,
        home: const Splash(), //MUISTA VAIHTAA TAKAISIN WELCOMEEN
      ),
    );
  }
}
