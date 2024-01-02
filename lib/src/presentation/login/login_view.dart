import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';
import 'package:qjumpa/src/presentation/login/bloc/login_user_bloc.dart';
import 'package:qjumpa/src/presentation/register_user/register_screen.dart';
import 'package:qjumpa/src/presentation/select_store/select_store_screen.dart';
import 'package:qjumpa/src/presentation/widgets/custom_textformfield.dart';
import 'package:qjumpa/src/presentation/widgets/large_button.dart';

class LoginView extends StatefulWidget {
  static const routeName = '/loginview';
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final loginUserBloc = sl.get<LoginUserBloc>();

  String? errorMessage = '';
  bool passwordVisible = false;

  bool isLogin = true;
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _phoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!RegExp(r'^(?:\+234|0)[789][01]\d{8}$').hasMatch(value)) {
      return 'Please enter a valid phone number';
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
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<LoginUserBloc, LoginUserState>(
      bloc: loginUserBloc,
      listener: (context, state) {
        if (state is LoginUserCompleted) {
          Navigator.pushReplacementNamed(context, SelectStoreScreen.routeName);
        } else if (state is ErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                  child: Text(
                state.messsge,
                style: const TextStyle(color: Colors.red),
              )),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.white,
            ),
          );
        }
      },
      child: Scaffold(
          body: BlocBuilder<LoginUserBloc, LoginUserState>(
        bloc: loginUserBloc,
        builder: (context, state) {
          if (state is LoginUserLoading) {
            return Stack(
              children: [
                Positioned(
                  top: screenHeight / 2.8,
                  left: screenHeight / 6,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Welcome..'),
                        SizedBox(
                          height: screenHeight / 23,
                        ),
                        CircularProgressIndicator.adaptive(
                          backgroundColor: HexColor(primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return loginScreenView(screenHeight, context);
        },
      )),
    );
  }

  Stack loginScreenView(double screenHeight, BuildContext context) {
    return Stack(children: [
      Positioned(
        top: screenHeight <= 667 ? screenHeight / 34 : screenHeight / 15,
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
                          validator: _phoneNumberValidator,
                          controller: _phoneNumberController,
                          hint: '123456789',
                          label: 'PHONE NUMBER',
                          value: false,
                          suffixIcon: null,
                          focus: true,
                          keyboardType: TextInputType.number,
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
                  onTap: () => {}
                  // Navigator.pushReplacementNamed(
                  //     context, UpdatePasswordScreen.routeName)
                  ,
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
                          loginUserBloc.add(
                            Login(
                              password: _passwordController.text.trim(),
                              mobileNumber: _phoneNumberController.text.trim(),
                            ),
                          );
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
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
