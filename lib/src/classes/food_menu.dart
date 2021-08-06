import 'editable.dart';
import 'food.dart';
import 'serializable.dart';
import 'owner_server.dart';
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
        _data = {}
  {
    id = json['ID'];
    for (var key in json.keys) {
      var category = Food.toCategory(key);
      if (category == null) continue;
      _data[category] = json[key].map<Food>((e) => Food.fromJson(e, server)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    var result = <String, dynamic>{};
    result['ID'] = id;
    _data.forEach((key, value) => result[key.toString()] = value.map((e) => e.id).toList(growable: false));
    return result;
  }


  @override
  Server get server => _server;

  List<FoodCategory> get categories => FoodCategory.values.where((element) => _data[element]!.isNotEmpty).toList(growable: false);

  void justAddFood(Food food) {
    _data[food.category]!.add(food);
  }

  Future<void> addFood(Food food) async {
    justAddFood(food);
    await (server as OwnerServer).addFood(this, food);
  }

  void justRemoveFood(Food food) {
    _data[food.category]!.remove(food);
  }

  Future<void> removeFood(Food food) async {
    justRemoveFood(food);
    await (server as OwnerServer).removeFood(this, food);
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
          subMenu.justAddFood(food);
        }
      }
    }
    return subMenu;
  }

  bool get isEmpty {
    if (_data.isEmpty) return true;

    for (var category in FoodCategory.values) {
      if (_data[category]?.isNotEmpty ?? false) return false;
    }

    return true;
  }

  bool get isNotEmpty => !isEmpty;
}