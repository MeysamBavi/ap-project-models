import 'food.dart';
import 'food_menu.dart';
import 'serializable.dart';

class Restaurant with Serializable {
  final String name;
  FoodMenu? _menu;
  final String? menuID;
  final foodCategories;
  // Address _address
  // Distance _areaOfDispatch
  double _score = 0;

  get score => _score;

  FoodMenu? get menu => _menu;

  Restaurant({
    required this.name,
    Set<FoodCategory>? this.foodCategories,
    required this.menuID,
    required double score
  }) {
    _score = score;
  }

}