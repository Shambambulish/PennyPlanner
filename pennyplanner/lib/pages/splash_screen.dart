import 'package:flutter/material.dart';
import 'package:pennyplanner/pages/welcome_page.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin{
  late AnimationController controller1;
  late Animation<Alignment> positionAnimation;
  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 5),  ()  {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const WelcomePage()));
    });
  }

  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          children: [

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

          /* Positioned(child: Container(
                 child: const Image(
                  image: AssetImage('assets/PPbottom.png'), #TESTINÄ SS FIGMAN SPLASH SCREEN
                 ),
                  
              ))
             
          */
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Color(0xffffe380)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                ],
              ),
              ),
             ),

          ],
        ),
        )
      );
  }
}