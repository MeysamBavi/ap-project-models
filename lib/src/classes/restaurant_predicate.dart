import 'restaurant.dart';
import 'food.dart';

class RestaurantPredicate {
  String? name;
  FoodCategory? category;

  bool Function(Restaurant) generate() {

    return (Restaurant restaurant) {
      return restaurant.name.contains(RegExp(name!, caseSensitive: false));
    };
  }

  bool get isNull => name == null && category == null;

  void setNull() {
    name = null;
    category = null;
  }

  Map<String, dynamic> toJson() => {
    'name' : name,
    'category' : category?.toString()
  };
}