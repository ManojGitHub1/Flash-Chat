// ignore_for_file: prefer_const_constructors

import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  bool showSpinner = false;

  FirebaseAuth _auth = FirebaseAuth.instance;
  String? email;
  String? password;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // @override
  // void dispose() {
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration Page"),
        backgroundColor: Colors.white10,
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
                    height: 150.0,
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
                height: 30.0,
              ),
              RoundedButton(
                  colour: Colors.blueAccent,
                  title: "Register",
                  onPressed: () async{
                    _emailController.clear();
                    _passwordController.clear();
                    setState(() {
                      showSpinner = true;
                    });
                    try{
                      UserCredential newUser = await _auth.createUserWithEmailAndPassword(email: email!, password: password!);
                      if(newUser != null){
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
