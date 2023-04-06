import 'package:flutter/material.dart';
import 'package:pennyplanner/pages/welcome_page.dart';

import '../../widgets/pp_appbar.dart';

const List<String> currencyValues = <String>['€', "USD", '£', '¥'];

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //SETTINGS
  //TESTAUSTA VARTEN, JOKU SETTINGS FILU ERIKSEEN
  String currencySetting = currencyValues.first;
  ThemeMode themeSetting = ThemeMode.light; //set system default
  bool toinenAsetus = false;
  bool kolmasAsetus = false;

  //////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PPAppBar(
        title: 'Home Page',
        returnToHomePage: false,
        showSettingsBtn: true,
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
                        const Text(
                          "Hi,",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        const Text(
                          "Yourname Here",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
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
                      const snackBar = SnackBar(content: Text('Signing out'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomePage()));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 35),
                      backgroundColor: const Color(0xffaf6363),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                    ),
                    child: const Text('SIGN OUT'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      // ***** DELETE ACCOUNT *********
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 35),
                      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                    ),
                    child: const Text('DELETE ACCOUNT'),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 30),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Settings",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Hind Siliguri",
                  color: Color(0xff0F5B2E),
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.only(left: 40, top: 10, bottom: 10),
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    DropdownButton(
                        value: currencySetting,
                        items: currencyValues
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            currencySetting = value!;
                          });
                        }),
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: const Text("Currency",
                          style: TextStyle(fontSize: 25)),
                    )
                  ],
                )),
            Container(
              padding: const EdgeInsets.only(left: 40, top: 10, bottom: 10),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Transform.scale(
                    scale: 2.0,
                    child: Checkbox(
                        value: themeSetting == ThemeMode.dark,
                        onChanged: (bool? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            if (value!) {
                              themeSetting = ThemeMode.dark;
                            } else {
                              themeSetting = ThemeMode.light;
                            }
                          });
                        }),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child:
                        const Text("Dark Mode", style: TextStyle(fontSize: 25)),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 40, top: 10, bottom: 10),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Transform.scale(
                      scale: 2.0,
                      child: Checkbox(
                          value: toinenAsetus == true,
                          onChanged: (bool? value) {
                            setState(() {
                              toinenAsetus = !toinenAsetus;
                            });
                          })),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: const Text("Joku toinen asetus",
                        style: TextStyle(fontSize: 25)),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 40, top: 10, bottom: 10),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Transform.scale(
                      scale: 2.0,
                      child: Checkbox(
                          value: kolmasAsetus == true,
                          onChanged: (bool? value) {
                            setState(() {
                              setState(() {
                                kolmasAsetus = !kolmasAsetus;
                              });
                            });
                          })),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: const Text("Joku kolmas asetus",
                        style: TextStyle(fontSize: 25)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
