import 'dart:async';
import 'dart:convert';

import 'package:qjumpa/src/domain/entity/shopping_list_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _shoppingListKey = "shopping_list_shared_preference_key";

class ShoppingListSharedPreferences {
  final SharedPreferences _sharedPreferences;
  final StreamController<int> _controller = StreamController<int>.broadcast();
  final StreamController<List<ShoppingListEntity>> _shoppingListController =
      StreamController<List<ShoppingListEntity>>.broadcast();

  Stream<int> get shoppingListCountStream => _controller.stream;
  Stream<List<ShoppingListEntity>> get shoppingListStream =>
      _shoppingListController.stream;

  int get shoppingListLength => getShoppingList().length;

  ShoppingListSharedPreferences(this._sharedPreferences) {
    final initialShoppingList = getShoppingList();
    _controller.add(initialShoppingList.length);
    _shoppingListController.add(initialShoppingList);
  }

  void updateIsExpanded(ShoppingListEntity newItem, bool isExpanded) {
    List<ShoppingListEntity> shoppingList = List.from(getShoppingList());
    final int index = shoppingList.indexWhere((item) => item.id == newItem.id);

    if (!index.isNegative) {
      final shoppingEntity = shoppingList[index];
      newItem = shoppingEntity.copyWith(
        isExpanded: isExpanded,
        title: shoppingEntity.title,
        body: shoppingEntity.body,
        id: shoppingEntity.id,
      );
      shoppingList[index] = newItem;
      _sharedPreferences.setString(_shoppingListKey, jsonEncode(shoppingList));
      _shoppingListController.add(shoppingList);
      _controller.add(shoppingList.length);
    }
  }

  void addNewShoppingList(ShoppingListEntity newItem) {
    final List<ShoppingListEntity> shoppingList =
        List<ShoppingListEntity>.from(getShoppingList());
    shoppingList.add(newItem);

    _sharedPreferences.setString(_shoppingListKey, jsonEncode(shoppingList));
    _shoppingListController.add(shoppingList);
    _controller.add(shoppingList.length);
  }

  void removeShoppingList(ShoppingListEntity item) {
    final shoppingList = getShoppingList();
    shoppingList.remove(item);
    _shoppingListController.add(shoppingList);
    _controller.add(shoppingList.length);
  }

  List<ShoppingListEntity> getShoppingList() {
    final res = _sharedPreferences.getString(_shoppingListKey);
    if (res == null || res.isEmpty) return List.empty();
    return List.from(jsonDecode(res))
        .map((e) => ShoppingListEntity.fromJson(e))
        .toList();
  }

  void dispose() {
    _controller.close();
    _shoppingListController.close();
  }
}
