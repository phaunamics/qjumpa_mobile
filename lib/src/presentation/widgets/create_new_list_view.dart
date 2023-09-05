import 'package:flutter/material.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/constants.dart';
import 'package:qjumpa/src/core/hex_converter.dart';
import 'package:qjumpa/src/data/local_storage/item_shared_preferences.dart';
import 'package:qjumpa/src/domain/entity/shopping_list_entity.dart';
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
    List<String> lines = text.split('\n');
    List<ItemBody> itemBodies =
        lines.map((line) => ItemBody.withId(content: line)).toList();

    return itemBodies;
  }

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
                decoration: const InputDecoration(hintText: 'Title'),
                textInputAction: TextInputAction.done,
              ),
              SizedBox(
                height: screenHeight / 23,
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
                decoration:
                    const InputDecoration(hintText: 'Create Shopping List'),
                textInputAction: TextInputAction.newline,
                maxLines: null,
              ),
            ],
          ),
        ),
        SizedBox(
          height: screenHeight / 13,
        ),
        LargeBtn(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              var title = _titleController.text;
              var itemBody = mapTextToItemBody(_listcontroller.text.trim());
              // print('item body is ${itemBody.toString()}');
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
                    style:
                        TextStyle(color: HexColor(primaryColor), fontSize: 17),
                  ),
                ),
              );
              Navigator.pop(context);
            }
          },
          text: 'Save',
          color: HexColor(primaryColor),
        )
      ],
    );
  }
}
