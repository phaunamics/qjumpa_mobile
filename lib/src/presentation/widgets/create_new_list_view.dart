import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/firebase_auth.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/data/local_storage/item_shared_preferences.dart';
import 'package:qjumpa/src/domain/entity/shopping_list_entity.dart';
import 'package:qjumpa/src/presentation/login/login_view.dart';
import 'package:qjumpa/src/presentation/widgets/large_button.dart';

class CreateNewListView extends StatefulWidget {
  const CreateNewListView({super.key});

  @override
  _CreateNewListViewState createState() => _CreateNewListViewState();
}

class _CreateNewListViewState extends State<CreateNewListView> {
  late TextEditingController _listcontroller;
  late TextEditingController _titleController;
  final _formKey = GlobalKey<FormState>();
  final _auth = sl.get<Auth>();

  final FocusNode _focusNode = FocusNode();
  final shoppingListSharedPref = sl.get<ShoppingListSharedPreferences>();

  @override
  void initState() {
    super.initState();
    _listcontroller = TextEditingController();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _listcontroller.dispose();
    super.dispose();
  }

  List<ItemBody> mapTextToItemBody(String text) {
    List<String> lines = text.trim().split('\n');
    List<ItemBody> itemBodies =
        lines.map((line) => ItemBody.withId(content: line)).toList();

    return itemBodies;
  }
  //  void checkIfUserIsLoggedIn() {
  //   if (_auth.currentUser != null) {
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (context) => const ShoppingListNavBar()));
  //   } else {
  //     loginRequestPopUp(context).show();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Create New Shopping List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, size: 30, color: Colors.red),
            ),
          ],
        ),
        SizedBox(
          height: screenHeight / 76,
        ),
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: true,
                validator: (value) {
                  if (!value!.isNotEmpty) {
                    return 'Cannot be empty';
                  }
                  return null;
                },
                focusNode: _focusNode,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    labelText: 'Title',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
                textInputAction: TextInputAction.done,
              ),
              SizedBox(
                height: screenHeight / 78,
              ),
              TextFormField(
                controller: _listcontroller,
                validator: (value) {
                  if (!value!.isNotEmpty) {
                    return 'Cannot be empty';
                  }
                  return null;
                },
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    labelText: 'Create Shopping List',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
                textInputAction: TextInputAction.newline,
                maxLines: 4,
              ),
            ],
          ),
        ),
        SizedBox(
          height: screenHeight / 23,
        ),
        LargeBtn(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              if (_auth.currentUser != null) {
                var title = _titleController.text;
                var itemBody = mapTextToItemBody(_listcontroller.text.trim());
                var item =
                    ShoppingListEntity.withId(body: itemBody, title: title);
                shoppingListSharedPref.addNewShoppingList(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    backgroundColor: Colors.grey.shade300,
                    content: Text(
                      '$title is saved',
                      style: TextStyle(
                          color: HexColor(primaryColor), fontSize: 17),
                    ),
                  ),
                );
                Navigator.pop(context);
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  backgroundColor: Colors.red, // Set a color for warning
                  content: Text(
                    'Please fields cannot be empty',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              );
            }
            if (_formKey.currentState!.validate()) {
              if (_auth.currentUser == null) {
                loginRequestPopUp(context).show();
              }
            }
          },
          text: 'Save',
          color: HexColor(primaryColor),
        )
      ],
    );
  }

  AwesomeDialog loginRequestPopUp(BuildContext context) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      padding: const EdgeInsets.only(bottom: 6),
      desc: 'Please login or register to create shopping list',
      btnOk: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: HexColor(primaryColor),
            borderRadius: BorderRadius.circular(8)),
        child: ElevatedButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, LoginView.routeName),
          style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide.none),
            backgroundColor: MaterialStateProperty.all(
              HexColor(primaryColor),
            ),
          ),
          child: const Text(
            'Login',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
