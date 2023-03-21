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
        title: 'Settings',
        returnToHomePage: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 70,
            left: 40,
            right: 40,
            child: Container(
              width: 422,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Stack(children: [
                Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(right: 60, top: 40),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Hi,",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 25,
                            )),
                        Text("Yourname Here",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold))
                      ]),
                ),
                Positioned(
                  left: 50,
                  top: 100,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email: yourname@here.com",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text("Member since 01.02.2023",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 25,
                              )),
                        ]),
                  ),
                )
              ]),
            ),
          ),
          Positioned(
            top: 30,
            left: 90,
            child: Image.asset(
              'assets/blank_profile_pic.png',
              width: 150,
              height: 150,
            ),
          ),
          Positioned(
              top: 350,
              bottom: 100,
              left: 50,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      child: Text("Settings",
                          style: TextStyle(
                              fontSize: 40,
                              fontFamily: "Hind Siliguri",
                              color: Color(0xff0F5B2E)))),
                  SizedBox(height: 25),
                  Container(
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
                                });
                              }),
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text("Currency",
                                style: TextStyle(fontSize: 25)),
                          )
                        ],
                      )),
                  SizedBox(height: 25),
                  Container(
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
                                    if (value!)
                                      themeSetting = ThemeMode.dark;
                                    else
                                      themeSetting = ThemeMode.light;
                                  });
                                }),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text("Dark Mode",
                                style: TextStyle(fontSize: 25)),
                          )
                        ],
                      )),
                  SizedBox(height: 25),
                  Container(
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
                            padding: EdgeInsets.only(left: 20),
                            child: Text("Joku toinen asetus",
                                style: TextStyle(fontSize: 25)),
                          )
                        ],
                      )),
                  SizedBox(height: 25),
                  Container(
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
                            padding: EdgeInsets.only(left: 20),
                            child: Text("Joku kolmas asetus",
                                style: TextStyle(fontSize: 25)),
                          )
                        ],
                      ))
                ],
              )),
          Positioned(
              left: 0,
              right: 0,
              bottom: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          const snackBar =
                              SnackBar(content: Text('Signing out'));
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
                      )),
                  SizedBox(height: 20),
                  Container(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // ***** DELETE ACCOUNT *********
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 35),
                          backgroundColor: Color.fromARGB(255, 255, 0, 0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0)),
                        ),
                        child: const Text('DELETE ACCOUNT'),
                      )),
                ],
              )),
        ],
      ),
    );
  }
}
