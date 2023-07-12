import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/presentation/login/login.dart';
import 'package:qjumpa/src/presentation/widgets/doodle_background.dart';

class SplashScreeen extends StatefulWidget {
  static const routeName = '/splashscreen';

  const SplashScreeen({super.key});

  @override
  State<SplashScreeen> createState() => _SplashScreeenState();
}

class _SplashScreeenState extends State<SplashScreeen> {
  late final Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, Login.routeName);
    });
  }

  @override
  void dispose() {
    if (timer.isActive) timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const DoodleBackground(),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: HexColor(primaryColor).withOpacity(0.92),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Image.asset('assets/logo.png')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
