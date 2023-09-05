import 'package:flutter/material.dart';
import 'package:qjumpa/src/presentation/widgets/create_new_list_view.dart';

class CreateNewListScreen extends StatelessWidget {
  static const routeName = '/create_new_shooping_list';
  const CreateNewListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
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
