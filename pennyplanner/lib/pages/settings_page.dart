import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pennyplanner/pages/buy_premium_page.dart';
import 'package:pennyplanner/pages/welcome_page.dart';
import 'package:pennyplanner/utils/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/pp_appbar.dart';
import '../utils/theme_provider.dart';

const List<String> currencyValues = <String>['€', "\$", '£', '¥'];
const List<String> languageValues = <String>["English", "Suomi"];

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  bool? isPremium = false;
  SettingsPage({super.key, this.isPremium});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? currencySetting;
  String? languageSetting;
  late bool darkModeCheckBoxValue; //set system default
  late Future<SharedPreferences> prefsFuture;
  late Future<DatabaseEvent> userNameFromDB;

  FirebaseDatabase db = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    // get user instance from database
    prefsFuture = SharedPreferences.getInstance();
    userNameFromDB = ref
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('username')
        .once();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PPColors ppColors = Theme.of(context).extension<PPColors>()!;
    darkModeCheckBoxValue = ppColors.isDarkMode;

    return FutureBuilder(
        future: Future.wait([prefsFuture, userNameFromDB]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            SharedPreferences prefs = snapshot.data![0];
            var prefCurrency = prefs.get("currency");
            currencySetting = (prefCurrency ?? currencyValues.first) as String;
            var prefLanguage = prefs.get("language");
            languageSetting = (prefLanguage ?? languageValues.first) as String;
            return Scaffold(
              appBar: const PPAppBar(
                title: 'Home Page',
                returnToHomePage: true,
                showSettingsBtn: false,
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/blank_profile_pic.png',
                            width: MediaQuery.of(context).size.width / 4,
                          ),
                          Container(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.hi,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                                Text(
                                  snapshot.data![1].snapshot.value,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.isPremium == false) ...{
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BuyPremiumPage(
                                              payload: "payload")));
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(150, 35),
                              backgroundColor:
                                  const Color.fromARGB(255, 59, 128, 255),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                            ),
                            child:
                                Text(AppLocalizations.of(context)!.buyPremium),
                          )
                        },
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20, bottom: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              var snackBar = SnackBar(
                                  content: Text(AppLocalizations.of(context)!
                                      .signingOut));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WelcomePage()));
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(150, 35),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                            ),
                            child: Text(AppLocalizations.of(context)!.signOut),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () async {
                              await ref
                                  .child('users')
                                  .child(FirebaseAuth.instance.currentUser!.uid)
                                  .remove()
                                  .then((value) => FirebaseAuth
                                          .instance.currentUser!
                                          .delete()
                                          .then((value) {
                                        var snackBar = SnackBar(
                                            content: Text(
                                                AppLocalizations.of(context)!
                                                    .accountDeleted));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const WelcomePage()));
                                      }));
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(150, 35),
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 0, 0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                            ),
                            child: Text(
                                AppLocalizations.of(context)!.deleteAccount),
                          ),
                        ],
                      ),
                    ),
                    //  if()

                    Container(
                      padding: const EdgeInsets.only(left: 30),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.settings,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Hind Siliguri",
                          color: ppColors.primaryTextColor,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(left: 40, top: 10, bottom: 10),
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          DropdownButton(
                              value: currencySetting,
                              items: currencyValues
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  currencySetting = value!;
                                  prefs.setString("currency", value);
                                });
                              }),
                          Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(AppLocalizations.of(context)!.currency,
                                style: const TextStyle(fontSize: 25)),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(left: 40, top: 10, bottom: 10),
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          DropdownButton(
                              value: languageSetting,
                              items: languageValues
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                LocaleProvider localeProvider =
                                    Provider.of<LocaleProvider>(context,
                                        listen: false);
                                localeProvider.setLocale(value!);
                                setState(() {
                                  languageSetting = value;
                                  prefs.setString("language", value);
                                });
                              }),
                          Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(AppLocalizations.of(context)!.language,
                                style: const TextStyle(fontSize: 25)),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(left: 40, top: 10, bottom: 10),
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Transform.scale(
                            scale: 2.0,
                            child: Checkbox(
                                checkColor: ppColors.isDarkMode
                                    ? Colors.black
                                    : Colors.white,
                                fillColor: ppColors.isDarkMode
                                    ? MaterialStateProperty.all(
                                        ppColors.primaryTextColor)
                                    : null,
                                value: darkModeCheckBoxValue,
                                onChanged: (bool? value) {
                                  ThemeProvider themeProvider =
                                      Provider.of<ThemeProvider>(context,
                                          listen: false);
                                  themeProvider.swapTheme(value!);
                                  setState(() {
                                    darkModeCheckBoxValue = value;
                                  });
                                }),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(AppLocalizations.of(context)!.darkMode,
                                style: const TextStyle(fontSize: 25)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
