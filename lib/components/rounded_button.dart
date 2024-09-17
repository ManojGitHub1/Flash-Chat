// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({super.key, required this.colour, required this.title, required this.onPressed});

  final Color colour;
  final String title;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colour,
          foregroundColor: Colors.white,
          elevation: 10,
          padding: EdgeInsets.all(18),
          textStyle: TextStyle(
            fontSize: 18,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
        ),
      ),
    );
  }
}