import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pennyplanner/pages/signup_page.dart';
import '../utils/auth_service.dart';
import '../utils/theme_provider.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final PPColors ppColors = Theme.of(context).extension<
        PPColors>()!; // Checking which mode the user has enabled (Dark/Light)
    return Scaffold(
      body: CustomScrollView(slivers: [
        // Forming the structure of the page
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: ppColors.isDarkMode
                        ? const Color(0xff111111)
                        : const Color(0xffaf6363)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      width: 230,
                      height: 230,
                      child: Image(
                        image: ppColors.isDarkMode
                            ? const AssetImage(
                                'assets/pplogo_red.png') // Depending on the chosen theme, an image is chosen
                            : const AssetImage('assets/pplogo.png'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Image(
                          image: ppColors.isDarkMode
                              ? const AssetImage('assets/pplogo_bold_red.png')
                              : const AssetImage(
                                  'assets/pplogo_bold_yellow.png')),
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
                        ? const Color(0xff333333)
                        : const Color(0xffffe380)),
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
                                AppLocalizations.of(context)!
                                    .login, //Local variable changes depening on the language chosen by the user
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
                                    style: const TextStyle(
                                        color: Colors
                                            .black), // TextField for the email
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
                                    // TextField for the password
                                    style: const TextStyle(color: Colors.black),
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
                              // start processing login data
                              {
                                try {
                                  //Check if all fields are filled
                                  if (emailController.text == "" ||
                                      passwordController.text == "") {
                                    var snackBar = SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .allFieldsRequired));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    return;
                                  }
                                  //Check email format
                                  if (EmailValidator.validate(
                                          emailController.text.trim()) ==
                                      false) {
                                    var snackBar = SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .emailFormatIncorrect));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    return;
                                  }
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim())
                                      .then((value) async {
                                    DatabaseReference ref =
                                        FirebaseDatabase.instance.ref();
                                    await ref
                                        .child("users")
                                        .child(value.user!.uid)
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
                                  });
                                  FirebaseAuth.instance
                                      .authStateChanges() // poista authstatechanges tarvittaessa, debug info bla bla
                                      .listen((User? user) {
                                    if (user == null) {
                                      if (kDebugMode) {
                                        print('User is currently signed out!');
                                      }
                                    } else {
                                      if (kDebugMode) {
                                        print('User is signed in!');
                                      }
                                      if (kDebugMode) {
                                        print('User id is:${user.uid}');
                                      }
                                    }
                                  });
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found' ||
                                      e.code == 'wrong-password') {
                                    var snackBar = SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .userOrPassIncorrect));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    if (kDebugMode) {
                                      print(
                                          'No user found for that email or password is incorrect');
                                    }
                                  }
                                }
                              }
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
                            onPressed: () async {
                              try {
                                await Authentication.signInWithGoogle(
                                        // Option for signing in with Google
                                        context: context)
                                    .then((value) async {
                                  DatabaseReference ref =
                                      FirebaseDatabase.instance.ref();
                                  bool userExists = (await ref
                                          .child('users')
                                          .child(value!.uid)
                                          .get())
                                      .exists;

                                  if (userExists == true) {
                                    // Check if user is found
                                    // User is found
                                    if (kDebugMode) {
                                      print("user found, no need to create");
                                    }
                                    await ref
                                        .child("users")
                                        .child(value.uid)
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
                                    if (kDebugMode) {
                                      print("No user found, creating");
                                    } // If user is not found, create a new user
                                    DatabaseReference ref = FirebaseDatabase
                                        .instance
                                        .ref('/users')
                                        .child(value.uid);
                                    ref.set({
                                      "username": value.displayName,
                                      "signUpDate":
                                          DateTime.now().toIso8601String(),
                                      "isPremium": false,
                                    });
                                    var snackBar = SnackBar(content: Text(
                                        // ignore: use_build_context_synchronously
                                        "${AppLocalizations.of(context)!.welcome}, ${usernameController.text}"));
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    // ignore: use_build_context_synchronously
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
                                    if (kDebugMode) {
                                      print('User is currently signed out!');
                                    }
                                  } else {
                                    if (kDebugMode) {
                                      print('User is signed in!');
                                    }
                                    if (kDebugMode) {
                                      print('User id is:${user.uid}');
                                    }
                                  }
                                });
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found' ||
                                    e.code == 'wrong-password') {
                                  var snackBar = SnackBar(
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .userOrPassIncorrect));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  if (kDebugMode) {
                                    print(
                                        'No user found for that email or password is incorrect');
                                  }
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
      ]),
    );
  }
}
