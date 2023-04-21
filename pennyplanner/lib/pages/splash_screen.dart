import 'package:flutter/material.dart';
import 'package:pennyplanner/pages/welcome_page.dart';

import '../utils/theme.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController controller1;
  late Animation<Alignment> positionAnimation;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const WelcomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final PPColors ppColors = Theme.of(context).extension<PPColors>()!;
    return Scaffold(
        body: Center(
      child: Column(
        children: [
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
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ppColors.isDarkMode
                      ? AssetImage('assets/PPBG_dark.png')
                      : AssetImage("assets/PPBG.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
