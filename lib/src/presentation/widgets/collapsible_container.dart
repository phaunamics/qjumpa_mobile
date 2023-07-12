import 'package:flutter/material.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/data/preferences/item_shared_preferences.dart';
import 'package:qjumpa/src/domain/entity/shopping_list_entity.dart';

class CollapsibleContainer extends StatefulWidget {
  const CollapsibleContainer({super.key});

  @override
  _CollapsibleContainerState createState() => _CollapsibleContainerState();
}

class _CollapsibleContainerState extends State<CollapsibleContainer> {
  final shoppingListSharedPref = sl.get<ShoppingListSharedPreferences>();

  @override
  void initState() {
    super.initState();
    shoppingListSharedPref.shoppingListStream.listen((shoppingList) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ShoppingListEntity>>(
      stream: shoppingListSharedPref.shoppingListStream,
      initialData: shoppingListSharedPref.getShoppingList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final shoppingList = snapshot.data!;
          return ListView.builder(
            itemCount: shoppingList.length,
            itemBuilder: (context, index) {
              final item = shoppingList[index];
              return CollapsibleListView(item);
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class CollapsibleListView extends StatefulWidget {
  final ShoppingListEntity item;

  const CollapsibleListView(this.item, {super.key});

  @override
  _CollapsibleListViewState createState() => _CollapsibleListViewState();
}

class _CollapsibleListViewState extends State<CollapsibleListView> {
  final shoppingListSharedPref = sl.get<ShoppingListSharedPreferences>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionPanelList(
        elevation: 1,
        expandedHeaderPadding: const EdgeInsets.all(0),
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            widget.item.isExpanded = !widget.item.isExpanded;
            shoppingListSharedPref.updateIsExpanded(
                widget.item, widget.item.isExpanded);
          });
        },
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(widget.item.title),
              );
            },
            body: SizedBox(
              height: screenHeight / 4.5,
              child: ListView.builder(
                itemCount: widget.item.body.length,
                itemBuilder: (context, index) {
                  final itemBody = widget.item.body[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: ListTile(
                      title: Row(
                        children: [
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: Image.asset(
                              'assets/pointer.jpeg',
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            width: screenHeight / 10,
                          ),
                          Text(
                            itemBody.content,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            isExpanded: widget.item.isExpanded,
          ),
        ],
      ),
    );
  }
}
