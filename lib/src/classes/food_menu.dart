import 'editable.dart';
import 'food.dart';
import 'serializable.dart';
import 'server.dart';

class FoodMenu with Serializable implements Editable {

  final Map<FoodCategory, List<Food>> _data = <FoodCategory, List<Food>>{};
  Server _server;

  FoodMenu(Server server) : _server = server;

  @override
  Server get server => _server;

  List<FoodCategory> get categories => _data.keys.toList();

  void addFood(Food food) {
    if (_data[food.category] == null) {
      _data[food.category] = <Food>[];
    }
    _data[food.category]!.add(food);
    server.edit(this);
  }

  void removeFood(Food food) {
    _data[food.category]?.remove(food);
    if (_data[food.category] == null || _data[food.category]!.isEmpty) {
      _data.remove(food.category);
    }
    server.edit(this);
  }

  List<Food>? getFoods(FoodCategory category) {
    return _data[category];
  }

  bool hasCategory(FoodCategory category) {
    return categories.contains(category);
  }

}