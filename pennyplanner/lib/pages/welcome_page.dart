import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pennyplanner/pages/home_page.dart';
import 'package:pennyplanner/utils/auth_service.dart';
import '../utils/theme_provider.dart';
import 'signin_page.dart';
import 'signup_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final PPColors ppColors = Theme.of(context).extension<PPColors>()!;
    return Scaffold(
      body: Center(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        const SignInPage(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 35),
                            backgroundColor: ppColors.isDarkMode
                                ? ppColors.primaryTextColor
                                : Theme.of(context).colorScheme.primary,
                            foregroundColor: ppColors.isDarkMode
                                ? Colors.black
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0)),
                          ),
                          child:
                              Text(AppLocalizations.of(context)!.loginButton),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        const SignUpPage(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 35),
                            backgroundColor: ppColors.isDarkMode
                                ? ppColors.primaryTextColor
                                : Theme.of(context).colorScheme.primary,
                            foregroundColor: ppColors.isDarkMode
                                ? Colors.black
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0)),
                          ),
                          child:
                              Text(AppLocalizations.of(context)!.signupButton),
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
                                    : Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            try {
                              await Authentication.signInWithGoogle(
                                      context: context)
                                  .then((value) async {
                                FirebaseDatabase db = FirebaseDatabase.instance;
                                DatabaseReference ref =
                                    FirebaseDatabase.instance.ref();
                                bool userExists = (await ref
                                        .child('users')
                                        .child(value!.uid)
                                        .get())
                                    .exists;

                                if (userExists == true) {
                                  print("user found, no need to create");
                                  await ref
                                      .child("users")
                                      .child(value!.uid)
                                      .child('isPremium')
                                      .once()
                                      .then((event) {
                                    var snackBar = SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .signingIn));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                isPremium:
                                                    (event.snapshot.value ??
                                                        false) as bool)),
                                        (Route<dynamic> route) => false);
                                  });
                                } else {
                                  print("No user found, creating");
                                  DatabaseReference ref = FirebaseDatabase
                                      .instance
                                      .ref('/users')
                                      .child(value!.uid);
                                  ref.set({
                                    "username": value.displayName,
                                    "signUpDate":
                                        DateTime.now().toIso8601String(),
                                    "isPremium": false,
                                  });
                                  var snackBar = SnackBar(
                                      content: Text(
                                          "${AppLocalizations.of(context)!.welcome}, ${usernameController.text}"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage(
                                                isPremium: false,
                                              )),
                                      (Route<dynamic> route) => false);
                                }
                              });
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
                              if (e.code == 'user-not-found' ||
                                  e.code == 'wrong-password') {
                                var snackBar = SnackBar(
                                    content: Text(AppLocalizations.of(context)!
                                        .userOrPassIncorrect));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                print(
                                    'No user found for that email or password is incorrect');
                              }
                            }
                          },
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
    );
  }
}
