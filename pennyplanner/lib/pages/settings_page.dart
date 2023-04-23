import 'package:flutter/material.dart';
import 'package:pennyplanner/pages/welcome_page.dart';
import 'package:pennyplanner/utils/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/pp_appbar.dart';
import '../utils/theme_provider.dart';

const List<String> currencyValues = <String>['€', "\$", '£', '¥'];
const List<String> languageValues = <String>["English", "Suomi"];

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //SETTINGS
  //TESTAUSTA VARTEN, JOKU SETTINGS FILU ERIKSEEN
  String? currencySetting;
  String? languageSetting;
  late bool darkModeCheckBoxValue; //set system default
  bool toinenAsetus = false;
  bool kolmasAsetus = false;
  Future<SharedPreferences>? prefsFuture;

  @override
  void initState() {
    prefsFuture = SharedPreferences.getInstance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PPColors ppColors = Theme.of(context).extension<PPColors>()!;
    darkModeCheckBoxValue = ppColors.isDarkMode;

    return FutureBuilder(
        future: prefsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            SharedPreferences prefs = snapshot.data!;
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
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.hi,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                                const Text(
                                  "Yourname Here",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, bottom: 40),
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
                            onPressed: () {
                              // ***** DELETE ACCOUNT *********
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
                                // This is called when the user selects an item.
                                setState(() {
                                  currencySetting = value!;
                                  prefs.setString("currency", value);
                                });
                              }),
                          Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(AppLocalizations.of(context)!.currency,
                                style: TextStyle(fontSize: 25)),
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
                                  languageSetting = value!;
                                  prefs.setString("language", value);
                                });
                              }),
                          Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(AppLocalizations.of(context)!.language,
                                style: TextStyle(fontSize: 25)),
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
                                style: TextStyle(fontSize: 25)),
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
