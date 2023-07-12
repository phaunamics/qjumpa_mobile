import 'package:flutter/material.dart';
import 'package:qjumpa/src/presentation/widgets/custom_textformfield.dart';
import 'package:qjumpa/src/presentation/widgets/doodle_background.dart';
import 'package:qjumpa/src/presentation/widgets/small_btn.dart';

class ChangeUserNameScreen extends StatefulWidget {
  static const routeName = '/changeusername';
  const ChangeUserNameScreen({super.key});

  @override
  State<ChangeUserNameScreen> createState() => _ChangeUserNameScreenState();
}

class _ChangeUserNameScreenState extends State<ChangeUserNameScreen> {
  final _oldUsernameController = TextEditingController();
  final _newUsernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Stack(children: [
      const DoodleBackground(),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 30,
                        )),
                  ],
                ),
                SizedBox(
                  height: screenHeight / 20,
                ),
                CustomTextFormField(
                  controller: _oldUsernameController,
                  hint: '@teenata',
                  label: 'Current Username',
                  value: false,
                  suffixIcon: null,
                ),
                SizedBox(
                  height: screenHeight / 43,
                ),
                CustomTextFormField(
                  controller: _newUsernameController,
                  hint: '@',
                  label: 'New username',
                  value: false,
                  suffixIcon: null,
                ),
                SizedBox(
                  height: screenHeight / 26,
                ),
                const SmallBtn(
                  text: 'Save',
                  onTap: null,
                ),
              ],
            ),
          ),
        ),
      )
    ]));
  }
}
