import 'dart:async';

import 'package:expance_manager/screens/expance_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ExpenseManager(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/saving.png',
            height: 100,
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: 'Exp',
                    style: GoogleFonts.aBeeZee(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 25)),
                TextSpan(
                    text: 'ense',
                    style: GoogleFonts.aBeeZee(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 25)),
                TextSpan(
                    text: ' Mana',
                    style: GoogleFonts.aBeeZee(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 25)),
                TextSpan(
                    text: 'ger',
                    style: GoogleFonts.aBeeZee(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                        fontSize: 25)),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Spend Wisely, Live Freely.',
            style: GoogleFonts.lato(fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    ));
  }
}
