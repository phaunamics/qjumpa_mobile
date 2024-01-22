import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';
import 'package:qjumpa/src/core/utils/validation_utils.dart';
import 'package:qjumpa/src/presentation/login/login_view.dart';
import 'package:qjumpa/src/presentation/register_user/bloc/register_user_bloc.dart';
import 'package:qjumpa/src/presentation/widgets/custom_textformfield.dart';
import 'package:qjumpa/src/presentation/widgets/large_button.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/registerscreen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final registerUserBloc = sl.get<RegisterUserBloc>();
  String? errorMessage = '';
  final _formKey = GlobalKey<FormState>();

  bool passwordVisible = false;
  bool confirmpasswordVisible = false;
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    confirmpasswordVisible = true;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<RegisterUserBloc, RegisterUserState>(
      bloc: registerUserBloc,
      listener: (context, state) {
        if (state is RegisterUserCompleted) {
          Navigator.pop(context);
        } else if (state is ErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                  child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              )),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.white,
            ),
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<RegisterUserBloc, RegisterUserState>(
          bloc: registerUserBloc,
          builder: (context, state) {
            if (state is RegisterUserLoading) {
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
            return _registerScreenView(screenHeight, context);
          },
        ),
      ),
    );
  }

  Widget _registerScreenView(double screenHeight, BuildContext context) {
    return Stack(
      children: [
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
                    height: screenHeight / 23,
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
                            hint: 'abc@gmail.com',
                            validator: ValidationUtils.isValidEmail,
                            label: 'E-MAIL',
                            value: false,
                            focus: false,
                            suffixIcon: null,
                          ),
                          SizedBox(
                            height: screenHeight / 38,
                          ),
                          CustomTextFormField(
                            controller: _phoneNumberController,
                            hint: '1234567890',
                            validator: ValidationUtils.isPhoneNumberValid,
                            label: 'PHONE NUMBER',
                            value: false,
                            focus: false,
                            suffixIcon: null,
                          ),
                          SizedBox(
                            height: screenHeight / 37,
                          ),
                          CustomTextFormField(
                            controller: _passwordController,
                            hint: 'password',
                            label: 'PASSWORD',
                            validator: ValidationUtils.isValidPassword,
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
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            registerUserBloc.add(RegisterUser(
                                _phoneNumberController.text.trim(),
                                _passwordController.text.trim(),
                                _emailController.text.trim()));
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
                            context, LoginView.routeName),
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
      ],
    );
  }
}
