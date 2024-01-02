import 'package:flutter/material.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/services/user_auth_service.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';
import 'package:qjumpa/src/presentation/login/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _prefs = sl.get<SharedPreferences>();
  final userAuthService = sl.get<UserAuthService>();

  Future<void> signOut() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Text('Are you Sure?');
        });
    await userAuthService.logout();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: screenHeight / 11,
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenHeight / 54),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              return Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.chevron_left,
                              size: 29,
                            )),
                        SizedBox(
                          width: screenHeight / 8,
                        ),
                        const Center(
                          child: Text(
                            'PROFILE',
                            style: TextStyle(
                                letterSpacing: 1,
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight / 37,
                    ),
                    customText(
                        text: '@${_prefs.getString(userEmail)?.split('@')[0]}'),
                    SizedBox(
                      height: screenHeight / 23,
                    ),
                    customText(
                      text: 'PROFILE',
                      color: HexColor(fontColor),
                    ),
                    SizedBox(
                      height: screenHeight / 37,
                    ),
                    customText(text: 'Change Password'),
                    SizedBox(
                      height: screenHeight / 37,
                    ),
                    customText(
                      text: 'Q-jumpa',
                      color: HexColor(fontColor),
                    ),
                    SizedBox(
                      height: screenHeight / 37,
                    ),
                    GestureDetector(
                        onTap: null, child: customText(text: 'Contact Us')),
                    SizedBox(
                      height: screenHeight / 43,
                    ),
                    GestureDetector(
                        onTap: () {
                          signOut();
                          Navigator.pushReplacementNamed(
                              context, LoginView.routeName);
                        },
                        child: customText(text: 'Logout', color: Colors.red)),
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
