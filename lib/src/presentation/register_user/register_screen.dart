import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/services/firebase_auth.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';
import 'package:qjumpa/src/presentation/login/login.dart';
import 'package:qjumpa/src/presentation/verification/email_verification.dart';
import 'package:qjumpa/src/presentation/widgets/custom_textformfield.dart';
import 'package:qjumpa/src/presentation/widgets/large_button.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/registerscreen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = sl.get<Auth>();
  String? errorMessage = '';
  final _formKey = GlobalKey<FormState>();

  bool passwordVisible = false;
  final bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<User?> createUserWithEmailAndPassword(
      {required String userEmail, required String password}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: HexColor(primaryColor),
        ),
      ),
    );
    try {
      await _auth.createUserWithEmailAndPassword(
          email: userEmail, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Weak Password')));
      } else if (e.code == 'email-already-in-exist') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('An account already exists for that email')));
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('invalid email format')));
      }
      setState(() {
        errorMessage = e.message;
      });
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
    _passwordController.dispose();
    _emailController.dispose();
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
                Image.asset('assets/register.jpeg'),
                SizedBox(
                  height: screenHeight / 12,
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenHeight / 45.0),
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: _emailController,
                          hint: 'user@email.com',
                          validator: (value) =>
                              value != null && !EmailValidator.validate(value)
                                  ? 'Enter a valid e-mail'
                                  : null,
                          label: 'EMAIL',
                          value: false,
                          focus: false,
                          suffixIcon: null,
                        ),
                        SizedBox(
                          height: screenHeight / 26,
                        ),
                        CustomTextFormField(
                          controller: _passwordController,
                          hint: 'password',
                          label: 'PASSWORD',
                          validator: (value) {
                            if (!(value!.length >= (6)) && value.isNotEmpty) {
                              return 'Enter min. of 6 characters.';
                            }
                            return null;
                          },
                          value: passwordVisible,
                          focus: false,
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
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight / 20,
                ),
                Row(children: [
                  Expanded(
                    child: LargeBtn(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await createUserWithEmailAndPassword(
                              password: _passwordController.text.trim(),
                              userEmail: _emailController.text.trim());
                        }
                        if (_auth.currentUser != null) {
                          Navigator.pushReplacementNamed(
                              context, EmailVerificationScreen.routeName);
                        }
                      },
                      text: 'Register',
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
                    Text('Registered already?',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: HexColor(fontColor))),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                          context, Login.routeName),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: screenHeight / 54,
                ),
              ],
            ),
          ),
        ),
      )
    ]));
  }
}
