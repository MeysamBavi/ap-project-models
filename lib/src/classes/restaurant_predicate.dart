import 'restaurant.dart';
import 'food.dart';

class RestaurantPredicate {
  String? name;
  FoodCategory? category;

  bool Function(Restaurant) generate() {

    return (Restaurant restaurant) {
      var result = true;

      if (name != null) {
        result = result && restaurant.name.contains(RegExp(name ?? '', caseSensitive: false));
      }
      if (category != null) {
        result = result && restaurant.foodCategories.contains(category);
      }
      return result;
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