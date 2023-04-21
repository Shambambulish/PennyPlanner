import 'package:flutter/material.dart';
import 'package:pennyplanner/pages/signup_page.dart';
import '../utils/theme_provider.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final PPColors ppColors = Theme.of(context).extension<PPColors>()!;
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: ppColors.isDarkMode
                        ? Color(0xff111111)
                        : Color(0xffaf6363)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      width: 230,
                      height: 230,
                      child: Image(
                        image: ppColors.isDarkMode
                            ? AssetImage('assets/pplogo_red.png')
                            : AssetImage('assets/pplogo.png'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Image(
                          image: ppColors.isDarkMode
                              ? AssetImage('assets/pplogo_bold_red.png')
                              : AssetImage('assets/pplogo_bold_yellow.png')),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: ppColors.isDarkMode
                        ? Color(0xff333333)
                        : Color(0xffffe380)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: ppColors.isDarkMode
                                        ? ppColors.primaryTextColor!
                                        : Colors.black),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 7),
                              child: Text(
                                AppLocalizations.of(context)!.login,
                                style: TextStyle(
                                    fontFamily: 'Hind Siliguri',
                                    fontSize: 27,
                                    color: ppColors.primaryTextColor),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(60, 10, 60, 0),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    AppLocalizations.of(context)!.email,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: ppColors.primaryTextColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 35,
                                  child: TextField(
                                    controller: emailController,
                                    cursorColor: Colors.black,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color:
                                                  ppColors.primaryTextColor!),
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color:
                                                  ppColors.primaryTextColor!),
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    AppLocalizations.of(context)!.password,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: ppColors.primaryTextColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 35,
                                  child: TextField(
                                    controller: passwordController,
                                    cursorColor: Colors.black,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color:
                                                  ppColors.primaryTextColor!),
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color:
                                                  ppColors.primaryTextColor!),
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              {
                                try {
                                  final credential = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim());
                                  FirebaseAuth.instance
                                      .authStateChanges() // poista authstatechanges tarvittaessa, debug info bla bla
                                      .listen((User? user) {
                                    if (user == null) {
                                      print('User is currently signed out!');
                                    } else {
                                      print('User is signed in!');
                                      print('User id is:' + user.uid);
                                    }
                                  });
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    print('No user found for that email.');
                                  } else if (e.code == 'wrong-password') {
                                    print(
                                        'Wrong password provided for that user.');
                                  }
                                }
                              }

                              var snackBar = SnackBar(
                                  content: Text(
                                      AppLocalizations.of(context)!.signingIn));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                  (Route<dynamic> route) => false);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(150, 35),
                              backgroundColor: ppColors.isDarkMode
                                  ? ppColors.primaryTextColor
                                  : Theme.of(context).colorScheme.primary,
                              foregroundColor: ppColors.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            child:
                                Text(AppLocalizations.of(context)!.loginButton),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: ppColors.isDarkMode
                                        ? ppColors.primaryTextColor!
                                        : Colors.black),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .continueWithSocialMedia,
                              style: TextStyle(
                                fontFamily: 'Hind Siliguri',
                                fontSize: 12,
                                color: ppColors.isDarkMode
                                    ? ppColors.primaryTextColor
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Image(
                                image: AssetImage('assets/google_logo.png')),
                            iconSize: 30,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ]),
    );
  }
}
