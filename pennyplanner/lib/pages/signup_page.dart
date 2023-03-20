import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xffaf6363)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      width: 230,
                      height: 230,
                      child: const Image(
                        image: AssetImage('assets/pplogo.png'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: const Image(
                          image: AssetImage('assets/pplogo_bold_yellow.png')),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xffffe380)),
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
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 7),
                              child: const Text(
                                'CREATE AN ACCOUNT',
                                style: TextStyle(
                                    fontFamily: 'Hind Siliguri',
                                    fontSize: 27,
                                    color: Color(0xff0F5B2E)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(60, 10, 60, 0),
                            child: Column(
                              children: [
                                const SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Username',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18, color: Color(0xff0F5B2E)),
                                  ),
                                ),
                                SizedBox(
                                  height: 35,
                                  child: TextField(
                                    cursorColor: Colors.black,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: Color(0xff0F5B2E)),
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: Color(0xff0F5B2E)),
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'E-mail',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18, color: Color(0xff0F5B2E)),
                                  ),
                                ),
                                SizedBox(
                                  height: 35,
                                  child: TextField(
                                    cursorColor: Colors.black,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: Color(0xff0F5B2E)),
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: Color(0xff0F5B2E)),
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Password',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18, color: Color(0xff0F5B2E)),
                                  ),
                                ),
                                SizedBox(
                                  height: 35,
                                  child: TextField(
                                    cursorColor: Colors.black,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: Color(0xff0F5B2E)),
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: Color(0xff0F5B2E)),
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
                            onPressed: () {
                              const snackBar =
                                  SnackBar(content: Text('Clicked SIGN UP'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(150, 35),
                              backgroundColor: const Color(0xffaf6363),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                            ),
                            child: const Text('SIGN UP'),
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
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                            ),
                            child: const Text(
                              'OR CONTINUE WITH SOCIAL MEDIA',
                              style: TextStyle(
                                fontFamily: 'Hind Siliguri',
                                fontSize: 12,
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
