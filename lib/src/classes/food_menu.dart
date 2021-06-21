import 'editable.dart';
import 'food.dart';
import 'serializable.dart';
import 'server.dart';

class FoodMenu with Serializable implements Editable {

  final Map<FoodCategory, List<Food>> _data;
  Server _server;

  FoodMenu(Server server): _server = server, _data = <FoodCategory, List<Food>>{} {
    for (var category in FoodCategory.values) {
      _data[category] = <Food>[];
    }
  }

  FoodMenu.fromJson(Map<String, dynamic> json, Server server):
        _server = server,
        _data = json.map((key, value) => MapEntry(Food.toCategory(key)!, value.map<Food>((e) => Food.fromJson(e, server)).toList()))
  {
    id = json['ID'];
  }

  Map<String, dynamic> toJson() {
    var result = <String, dynamic>{};
    result['ID'] = id;
    _data.forEach((key, value) => result[key.toString()] = value);
    return result;
  }


  @override
  Server get server => _server;

  List<FoodCategory> get categories => FoodCategory.values.where((element) => _data[element]!.isNotEmpty).toList(growable: false);

  void addFood(Food food) {
    _data[food.category]!.add(food);
    server.edit(this);
  }

  void removeFood(Food food) {
    _data[food.category]!.remove(food);
    server.edit(this);
  }

  List<Food>? getFoods(FoodCategory category) {
    return _data[category];
  }

  bool hasCategory(FoodCategory category) {
    return categories.contains(category);
  }

  // returns a new menu with all the foods that predicate returns true on them
  FoodMenu toSubMenu(bool Function(Food) predicate) {
    var subMenu = FoodMenu(server);
    for (var category in FoodCategory.values) {
      for (Food food in _data[category] ?? const []) {
        if (predicate(food)) {
          subMenu.addFood(food);
        }
      }
    }
    return subMenu;
  }
}