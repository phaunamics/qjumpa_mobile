import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/services/user_auth_service.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';
import 'package:qjumpa/src/presentation/login/login_view.dart';
import 'package:qjumpa/src/presentation/select_store/select_store_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreeen extends StatefulWidget {
  static const routeName = '/splashscreen';

  const SplashScreeen({super.key});

  @override
  State<SplashScreeen> createState() => _SplashScreeenState();
}

class _SplashScreeenState extends State<SplashScreeen> {
  late final Timer timer;
  final _prefs = sl.get<SharedPreferences>();

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: 4), () {
      if (_prefs.getString(authTokenKey) == null) {
        Navigator.pushReplacementNamed(context, LoginView.routeName);
      } else {
        Navigator.pushReplacementNamed(context, SelectStoreScreen.routeName);
      }
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
          Image.asset('assets/watermark.jpg'),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: HexColor(primaryColor).withOpacity(0.82),
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
