import 'food.dart';
import 'serializable.dart';

class FoodMenu with Serializable {

  final Map<FoodCategory, List<Food>> _data = <FoodCategory, List<Food>>{};

  List<FoodCategory> get categories => _data.keys.toList();

  void addFood(Food food) {
    if (_data[food.category] == null) {
      _data[food.category] = <Food>[];
    }
    _data[food.category]!.add(food);
  }

  void removeFood(Food food) {
    _data[food.category]?.remove(food);
    if (_data[food.category] == null || _data[food.category]!.isEmpty) {
      _data.remove(food.category);
    }
  }

  List<Food>? getFoods(FoodCategory category) {
    return _data[category];
  }

  bool hasCategory(FoodCategory category) {
    return categories.contains(category);
  }

}