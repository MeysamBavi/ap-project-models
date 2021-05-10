import 'food.dart';
import 'food_menu.dart';
import 'serializable.dart';
import 'address.dart';

class Restaurant with Serializable {
  final String name;
  FoodMenu? menu;
  final String? menuID;
  final foodCategories;
  Address? address;
  double? areaOfDispatch; // in meters
  final double score;
  final List<String> commentIDs;

  Restaurant({
    required this.name,
    Set<FoodCategory>? this.foodCategories,
    required this.menuID,
    required this.score,
    this.address,
    this.areaOfDispatch,
  })  : commentIDs = [];

}