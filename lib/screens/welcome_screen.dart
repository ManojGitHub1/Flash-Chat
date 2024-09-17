// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/components/carousel_slider.dart';

class WelcomeScreen extends StatefulWidget {
  // creating id for routes and static is modifier, no need to create object WelcomeScreen()
  // static String id = 'welcome_screen';
  // by adding const we can't change
  static const String id = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  // by adding SingleTickerProvider class acts as TickerProvider
  late AnimationController controller;
  late Animation animation;
  int strikeCount = 0;
  final int maxStrikes = 8;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
      // if using curvedAnimation upperBound should be 1
      // upperBound: 100.0,
    );
    // CurvedAnimation
    // animation = CurvedAnimation(
    //     parent: controller,
    //     curve: Curves.decelerate,
    //   // decelerate - starts faster and goes slow
    //   // (values from 0 increases faster, towards 1 increases slower)
    // );

    //TweenAnimation
    // animation = ColorTween(begin: Colors.grey.shade700, end: Colors.white).animate(controller);
    animation = ColorTween(begin: Colors.grey.shade800, end: Colors.white).animate(controller);
    controller.forward();
    // reverse gives values from 1-0
    // controller.reverse(from: 1.0);


    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed){
    //     controller.reverse(from: 1.0);
    //   }else if(status == AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    // });

    controller.addListener(() {
      setState(() {});
      // print(controller.value);
      // print(animation.value);
    });
  }

  @override
  void dispose() {
    super.dispose();
    // addStatusListener runs for eternity wasting resource so dispose controller
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'logo',
                        child: Container(
                          // height: controller.value,
                          // upperbound can't be more than 1 & height from 0-1 is nothing so *100
                          // height: animation.value * 100,
                          height: 60.0,
                          child: Image.asset('images/logo.png'),
                        ),
                      ),
                      DefaultTextStyle(
                        // '${controller.value.toInt()}%',
                        style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                        ),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText('Flash Chat',
                                speed: const Duration(milliseconds: 300),
                                textStyle: TextStyle(
                                  color: Colors.black,
                                )),
                          ],
                          totalRepeatCount: 5,
                          pause: const Duration(milliseconds: 100),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  RoundedButton(
                    colour: Colors.lightBlueAccent,
                    title: "Log In",
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                  ),
                  RoundedButton(
                    colour: Colors.blueAccent,
                    title: "Register",
                    onPressed: () {
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
