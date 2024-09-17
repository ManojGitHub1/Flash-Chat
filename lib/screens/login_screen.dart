// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool showSpinner = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  String? email;
  String? password;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // @override
  // void dispose() {
  //   setState(() {
  //     _emailController.dispose();
  //     _passwordController.dispose();
  //   });
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
        backgroundColor: Colors.white12,
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.all(8),
          // wrap with this SingleChildScrollView for flexible
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter you email')
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter you password')
              ),
              SizedBox(
                height: 30,
              ),
              RoundedButton(
                  colour: Colors.lightBlueAccent,
                  title: "Log In",
                  onPressed: () async {
                    _emailController.clear();
                    _passwordController.clear();
                    setState(() {
                      showSpinner = true;
                    });
                    try{
                      UserCredential existUser = await _auth.signInWithEmailAndPassword(email: email!, password: password!);
                      if(existUser != null){
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    }catch (e) {
                      print(e);
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text("Registration Failed"),
                          content: Text(e.toString()),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                setState(() {
                                  showSpinner = false;
                                });
                              },
                              child: Text("OK"),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
