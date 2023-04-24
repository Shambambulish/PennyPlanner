import 'package:firebase_database/firebase_database.dart';
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
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //if initialvalues are null, set to default
  if (prefs.getString("currency") == null) {
    prefs.setString("currency", "€");
  }
  if (prefs.getString("language") == null) {
    prefs.setString("language", "English");
  }
  if (prefs.getBool("isDarkMode") == null) {
    prefs.setBool("isDarkMode", false);
  }
  //set notifier providers
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (BuildContext context) =>
              ThemeProvider(isDarkMode: prefs.getBool("isDarkMode")!)),
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

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Penny Planner',
        theme: themeProvider.getTheme, //get theme from ThemeProvider
        home: const Splash(),
        locale: localeProvider.locale, //get locale from LocaleProvider
        supportedLocales: PPLocales.all, //supported locales from l10n/l10n.dart
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
