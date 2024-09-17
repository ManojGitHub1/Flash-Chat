
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService{

  FirebaseAuth _auth = FirebaseAuth.instance;

  get context => null;

  Future<User?> signUpWithEmailandPassword(String email, String password) async{

    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email!, password: password!);
      return credential.user;
    }catch (e) {
      print(e);
    }

    return null;
  }

}