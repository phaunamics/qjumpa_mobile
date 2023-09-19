import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/main.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/firebase_auth.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/presentation/register_user/register_screen.dart';
import 'package:qjumpa/src/presentation/update_password/update_password_screen.dart';
import 'package:qjumpa/src/presentation/widgets/custom_textformfield.dart';
import 'package:qjumpa/src/presentation/widgets/large_button.dart';

class LoginView extends StatefulWidget {
  static const routeName = '/loginview';
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final auth = sl.get<Auth>();
  final _formKey = GlobalKey<FormState>();

  String? errorMessage = '';
  bool passwordVisible = false;

  bool isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<User?> signInWithEmailAndPassword(
      {required String userEmail, required String password}) async {
    try {
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) => Scaffold(
      //     backgroundColor: Colors.transparent,
      //     body: Column(
      //       children: [
      //         SizedBox(
      //           height: MediaQuery.of(context).size.height / 4,
      //         ),
      //         Center(
      //           child: CircularProgressIndicator(
      //             color: HexColor(primaryColor),
      //           ),
      //         ),
      //         SizedBox(
      //           height: MediaQuery.of(context).size.height / 20,
      //         ),
      //         const Text(
      //           'Welcome ...',
      //           style: TextStyle(fontSize: 25, color: Colors.white),
      //         ),
      //       ],
      //     ),
      //   ),
      // );
      await auth.signInWithEmailAndPassword(
          email: userEmail, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            backgroundColor: Colors.grey.shade300,
            content: const Text(
              'Incorrect login details. Check email or password',
              style: TextStyle(color: Colors.red, fontSize: 17),
            ),
          ),
        );
      } else if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            backgroundColor: Colors.grey.shade300,
            content: const Center(
              child: Text(
                'user not found. Please create an account',
                style: TextStyle(color: Colors.red, fontSize: 17),
              ),
            ),
          ),
        );
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            backgroundColor: Colors.grey.shade300,
            content: const Text(
              'Incorrect login details. Check email or password',
              style: TextStyle(color: Colors.red, fontSize: 17),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            backgroundColor: Colors.grey.shade300,
            content: const Text(
              'Check your internet connection',
              style: TextStyle(color: Colors.red, fontSize: 17),
            ),
          ),
        );
      }
      setState(() {
        errorMessage = e.code;
      });
    }

    // navigatorKey.currentState!.popUntil((route) => route.isFirst);
    navigatorKey.currentState!.pop();
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(children: [
      Positioned(
        top: screenHeight / 15,
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenHeight / 54),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight / 16,
                ),
                Image.asset('assets/Login.png'),
                SizedBox(
                  height: screenHeight / 28.9,
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenHeight / 45.0),
                    child: Column(
                      children: [
                        CustomTextFormField(
                          validator: _emailValidator,
                          controller: _emailController,
                          hint: 'user@email.com',
                          label: 'EMAIL',
                          value: false,
                          suffixIcon: null,
                          focus: true,
                        ),
                        SizedBox(
                          height: screenHeight / 26,
                        ),
                        CustomTextFormField(
                          validator: _passwordValidator,
                          controller: _passwordController,
                          hint: 'password',
                          label: 'PASSWORD',
                          value: passwordVisible,
                          suffixIcon: IconButton(
                            iconSize: 18,
                            color: HexColor(primaryColor),
                            icon: Icon(passwordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined),
                            onPressed: () {
                              setState(
                                () {
                                  passwordVisible = !passwordVisible;
                                },
                              );
                            },
                          ),
                          focus: true,
                        ),
                      ],
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(
                      context, UpdatePasswordScreen.routeName),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight / 40, bottom: screenHeight / 48),
                    child: Text(
                      'Forgot Password',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: HexColor(fontColor),
                          letterSpacing: 0.5),
                    ),
                  ),
                ),
                Row(children: [
                  Expanded(
                    child: LargeBtn(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await signInWithEmailAndPassword(
                              password: _passwordController.text.trim(),
                              userEmail: _emailController.text.trim());
                        }
                      },
                      text: 'Login',
                      color: HexColor(primaryColor),
                    ),
                  )
                ]),
                SizedBox(
                  height: screenHeight / 26,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don’t have an account yet?',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: HexColor(fontColor)),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                          context, RegisterScreen.routeName),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: screenHeight / 54,
                ),
                // IconButton(
                //   onPressed: () => Navigator.pushReplacementNamed(
                //       context, StoreSearchScreen.routeName),
                //   icon: const Icon(Icons.close),
                //   iconSize: 13,
                // )
              ],
            ),
          ),
        ),
      )
    ]));
  }
}
