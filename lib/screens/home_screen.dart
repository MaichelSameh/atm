import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:atm_app/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  // ignore: constant_identifier_names
  static const String route_name = "home-screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> names = [];

  int typingSpeed = 150;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void init() {
    var temp = [
      "Maichel Sameh",
      "Ziad Abdelfatah",
      "Raul Robert",
      "Sohir Hany",
      "Rana Khaled",
      "Nada Hany",
      "Nour Hany",
      "Rokya Ahmed",
      "Shahed Mahmod",
      "Reham Hassan",
      "Alla Bha",
      "Sondos",
      "Ahd Abdelqader",
      "Alea El Said",
      "Rehab El Said"
    ];
    if (temp.length == names.length) {
      names.clear();
      setState(() {});
      Timer(Duration(milliseconds: typingSpeed), init);
      return;
    }
    names.add(temp[names.length]);
    setState(() {});
    Timer(Duration(milliseconds: names.last.length * typingSpeed + typingSpeed),
        init);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          for (String name in names)
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  name,
                  textStyle: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  speed: Duration(milliseconds: typingSpeed),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 300),
              displayFullTextOnTap: false,
              stopPauseOnTap: false,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              SignInScreen.route_name, (route) => true);
        },
        backgroundColor: const Color.fromRGBO(158, 194, 68, 1),
        icon: const Text(
          "Start",
          style: TextStyle(color: Color.fromRGBO(11, 32, 45, 1)),
        ),
        label: const Icon(
          Icons.navigate_next,
          color: Color.fromRGBO(11, 32, 45, 1),
        ),
      ),
    );
  }
}
