import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/firebase_auth.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/presentation/shopping_list/shopping_list.dart';
import 'package:qjumpa/src/presentation/widgets/doodle_background.dart';
import 'package:qjumpa/src/presentation/widgets/small_btn.dart';

class EmailVerificationScreen extends StatefulWidget {
  static const routeName = '/emailverification';
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _auth = sl.get<Auth>();
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    _auth.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
    super.initState();
  }

  checkEmailVerified() async {
    await _auth.currentUser?.reload();
    setState(() {
      isEmailVerified = _auth.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      Navigator.pushReplacementNamed(context, ShoppingList.routeName);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email Successfully Verified"),
        ),
      );

      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          const DoodleBackground(),
          Positioned(
            top: screenHeight / 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Please your check email ${_auth.currentUser?.email} \n and click on the link to verify ',
                      style: const TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                      child: CircularProgressIndicator(
                    color: HexColor(primaryColor),
                  )),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: Center(
                      child: Text(
                        'Verifying email....',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 57),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: SmallBtn(
                      text: 'Resend',
                      onTap: () {
                        try {
                          _auth.currentUser?.sendEmailVerification();
                        } catch (e) {
                          debugPrint('$e');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
