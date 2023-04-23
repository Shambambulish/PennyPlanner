import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/auth_service.dart';
import 'home_page.dart';
import '../utils/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference ref =
    FirebaseDatabase.instance.ref('/users').child(usernameController.text);

final emailController = TextEditingController();
final usernameController = TextEditingController();
final passwordController = TextEditingController();
final firebase = FirebaseDatabase.instance.ref();

class SignUpPageState extends State<SignUpPage> {
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
                                AppLocalizations.of(context)!.createAnAccount,
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
                                    AppLocalizations.of(context)!.username,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: ppColors.primaryTextColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 35,
                                  child: TextField(
                                    controller: usernameController,
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
                                    AppLocalizations.of(context)!.email,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: ppColors.primaryTextColor!),
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
                                        color: ppColors.primaryTextColor!),
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
                              const snackBar =
                                  SnackBar(content: Text('Clicked SIGN UP'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              try {
                                final credential = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  print('The password provided is too weak.');
                                } else if (e.code == 'email-already-in-use') {
                                  print(
                                      'The account already exists for that email.');
                                }
                              } catch (e) {
                                print(e);
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                            ),
                            child: Text(
                                AppLocalizations.of(context)!.signupButton),
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
                              //odottaa käyttäjän todennuksen
                              User? user =
                                  await Authentication.signInWithGoogle(
                                      context: context);

                              if (user != null) {
                                if (!context.mounted) return;
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => HomePage(
                                              //siirtää etusivulle kirjautumisen onnistuessa
                                              user: user,
                                            )));
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
