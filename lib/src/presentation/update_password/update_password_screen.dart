import 'package:flutter/material.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/utils/constants.dart';
import 'package:qjumpa/src/core/services/firebase_auth.dart';
import 'package:qjumpa/src/core/utils/hex_converter.dart';
import 'package:qjumpa/src/presentation/login/login.dart';
import 'package:qjumpa/src/presentation/widgets/custom_textformfield.dart';
import 'package:qjumpa/src/presentation/widgets/large_button.dart';

class UpdatePasswordScreen extends StatefulWidget {
  static const routeName = '/updatepaswword';
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

enum AuthStatus { successful, unsuccessful }

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  String? errorMessage = '';
  static late AuthStatus _status;
  final _auth = sl.get<Auth>();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  Future<AuthStatus> resetPassword({required String email}) async {
    await _auth
        .resetPassword(email: email)
        .then((value) => _status = AuthStatus.successful);
    return _status;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Stack(children: [
      Positioned(
        top: screenHeight / 10,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenHeight / 43),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'RESET PASSWORD',
                      style: TextStyle(
                          letterSpacing: 2,
                          fontSize: 12,
                          color: HexColor(fontColor),
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, Login.routeName),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 30,
                        )),
                  ],
                ),
                SizedBox(
                  height: screenHeight / 29,
                ),
                Form(
                  key: _formKey,
                  child: CustomTextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email cannot be empty';
                      }
                      return null;
                    },
                    hint: 'email',
                    label: 'Email',
                    value: false,
                    focus: false,
                    suffixIcon: null,
                  ),
                ),
                SizedBox(
                  height: screenHeight / 32,
                ),
                LargeBtn(
                    color: HexColor(primaryColor),
                    text: 'Reset Password',
                    fontSize: 14,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        final status = await resetPassword(
                            email: _emailController.text.trim());
                        if (status == AuthStatus.successful) {
                          Navigator.pushReplacementNamed(
                              context, Login.routeName);
                        } else {
                          //your logic or show snackBar with error message
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
      )
    ]));
  }
}
