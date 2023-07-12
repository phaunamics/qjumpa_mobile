import 'package:flutter/material.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/firebase_auth.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/presentation/login/login_view.dart';
import 'package:qjumpa/src/presentation/widgets/doodle_background.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = sl.get<Auth>();

  Future<void> signOut() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Text('Are you Sure?');
        });
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          const DoodleBackground(),
          Positioned(
            top: screenHeight / 15,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenHeight / 54),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'PROFILE',
                        style: TextStyle(
                            letterSpacing: 2,
                            fontSize: 12,
                            color: HexColor(fontColor),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight / 37,
                    ),
                    Center(
                      child: CircleAvatar(
                        backgroundColor: HexColor(primaryColor),
                        radius: screenHeight / 17,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 39,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding:
                    //       EdgeInsets.symmetric(vertical: screenHeight / 74),
                    //   child: Center(child: customText(text: '@tetenta')),
                    // ),
                    SizedBox(
                      height: screenHeight / 23,
                    ),
                    customText(text: 'PROFILE', color: HexColor(fontColor)),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight / 43),
                      child: customText(text: 'Change Password'),
                    ),
                    customText(text: 'Change Username '),
                    SizedBox(
                      height: screenHeight / 37,
                    ),
                    customText(text: 'Q-jumpa', color: HexColor(fontColor)),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight / 43),
                      child: customText(text: 'Rate on Playstore'),
                    ),
                    customText(text: 'Contact Us'),
                    SizedBox(
                      height: screenHeight / 43,
                    ),
                    GestureDetector(
                        onTap: () {
                          _auth.signOut();
                          Navigator.pushReplacementNamed(
                              context, LoginView.routeName);
                        },
                        child: customText(text: 'Logout', color: Colors.red)),
                    SizedBox(
                      height: screenHeight / 4.5,
                    ),
                    Center(
                      child: IconButton(
                          onPressed: () {
                            return Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 40,
                            color: Colors.red,
                          )),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget customText({
    required String text,
    Color color = Colors.black,
  }) {
    return Text(
      text,
      style: TextStyle(
          letterSpacing: 1,
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: color),
    );
  }
}
