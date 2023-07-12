import 'package:flutter/material.dart';
import 'package:qjumpa/src/presentation/widgets/create_new_list_view.dart';
import 'package:qjumpa/src/presentation/widgets/doodle_background.dart';

class CreateNewListScreen extends StatelessWidget {
  static const routeName = '/create_new_shooping_list';
  const CreateNewListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          const DoodleBackground(),
          Positioned(
            top: screenHeight / 15,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Center(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: CreateNewListView(),
              )),
            ),
          )
        ],
      ),
    );
  }
}
