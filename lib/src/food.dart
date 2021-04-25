import 'serializable.dart';
import 'price.dart';

class Food with Serializable {

  String name;
  Price price;
  String? description;
  bool isAvailable;
  //Image? image;
  FoodCategory category;

  Food({
    required this.name,
    required this.category,
    required this.price,
    this.description,
    this.isAvailable = true,
    //image
  });

  FoodData toFoodData() => FoodData(name, price);

}

class FoodData {
  final String name;
  final Price price;
  FoodData(this.name, this.price);
}

enum FoodCategory {
  Iranian,
  FastFood,
  SeaFood
}