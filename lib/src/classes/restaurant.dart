import 'food.dart';
import 'food_menu.dart';
import 'serializable.dart';

class Restaurant with Serializable {
  final String name;
  FoodMenu? menu;
  final String? menuID;
  final foodCategories;
  // Address _address
  // Distance _areaOfDispatch
  final double score;
  final List<String> commentIDs;

  Restaurant({
    required this.name,
    Set<FoodCategory>? this.foodCategories,
    required this.menuID,
    required this.score
  })  : commentIDs = [];

}