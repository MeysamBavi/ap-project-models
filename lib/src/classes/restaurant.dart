import 'food.dart';
import 'food_menu.dart';
import 'serializable.dart';
import 'address.dart';

class Restaurant with Serializable {
  final String name;
  FoodMenu? menu;
  final String? menuID;
  final Set<FoodCategory> foodCategories;
  Address address;
  double areaOfDispatch; // in meters
  final double score;
  final List<String> commentIDs;

  Restaurant({
    required this.name,
    Set<FoodCategory>? foodCategories,
    required this.menuID,
    required this.score,
    required this.address,
    this.areaOfDispatch = 0,
  })  : commentIDs = [],
        this.foodCategories = foodCategories ?? {};

}