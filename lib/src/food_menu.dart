import 'food.dart';
import 'serializable.dart';

class FoodMenu with Serializable {

  final Map<String, Food> _foodMap = <String, Food>{};
  final Map<FoodCategory, List<Food>> _data = <FoodCategory, List<Food>>{};

  List<FoodCategory> get categories => _data.keys.toList();

  void addFood(Food food) {
    if (_data[food.category] == null) {
      _data[food.category] = <Food>[];
    }
    _data[food.category]!.add(food);
    _foodMap[food.name] = food;
  }

  Food? getFoodByName(String name) {
    return _foodMap[name];
  }

  void removeFoodByName(String name) {
    var food = getFoodByName(name);
    _data[food?.category]?.remove(food);
    _foodMap.remove(name);
  }

  List<Food>? getFoods(FoodCategory category) {
    return _data[category];
  }

  bool hasCategory(FoodCategory category) {
    return _data[category] != null;
  }

}