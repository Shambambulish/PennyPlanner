import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pennyplanner/firebase_options.dart';
import 'package:pennyplanner/l10n/l10n.dart';
import 'package:pennyplanner/utils/locale_provider.dart';
import 'package:pennyplanner/utils/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pennyplanner/pages/home_page.dart';
import 'package:pennyplanner/pages/settings_page.dart';
import 'pages/splash_screen.dart';
import '../pages/welcome_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //käynnistetään firebase applikaatiossa
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (BuildContext context) =>
              ThemeProvider(isDarkMode: prefs.getBool("isDarkTheme")!)),
      ChangeNotifierProvider(
          create: (BuildContext context) =>
              LocaleProvider(prefsLocale: prefs.getString("language")))
    ], child: const MyApp()),
  );

  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: ["CF3967800E18D9F4B4B5FDAECECEC421"]);
  MobileAds.instance.updateRequestConfiguration(configuration);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => MaterialApp(
        title: 'Penny Planner',
        theme: themeProvider.getTheme,
        home: const Splash(), //MUISTA VAIHTAA TAKAISIN WELCOMEEN
        locale: localeProvider.locale,
        supportedLocales: PPLocales.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
}
