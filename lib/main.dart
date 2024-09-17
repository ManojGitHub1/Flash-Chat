// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/landing_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: dotenv.env['apiKey']!,
          appId: dotenv.env['appId']!,
          messagingSenderId: dotenv.env['messagingSenderId']!,
          projectId: dotenv.env['projectId']!,
          storageBucket: dotenv.env['storageBucket']!
      )
  );
  runApp(FlashChat());
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.dark().copyWith(
      //   textTheme: TextTheme(
      //     bodyMedium: TextStyle(color: Colors.black54),
      //   ),
      // ),
      // home: WelcomeScreen(),
      initialRoute: LandingScreen.id,
      routes: {
        LandingScreen.id: (context) => LandingScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
