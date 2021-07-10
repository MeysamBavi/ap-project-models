import 'editable.dart';
import 'serializable.dart';
import 'price.dart';
import 'server.dart';
import 'small_data.dart';
import 'package:flutter/material.dart';

class Food with Serializable implements Editable {

  String name;
  Price price;
  String description;
  bool isAvailable;
  FoodCategory category;
  Server _server;
  Image image;

  Food({
    required String name,
    required FoodCategory category,
    required Price price,
    Image? image,
    String? description,
    bool isAvailable = true,
    required Server server
  }) :
        name = name,
        category = category,
        price = price,
        image = image ?? Image.asset('assets/default_food.jpg' , package: 'models',),
        description = description ?? '',
        isAvailable = isAvailable,
        _server = server;

  Food.fromJson(Map<String, dynamic> json, Server server):
        _server = server,
        name = json['name'],
        price = Price(int.parse(json['price'])),
        description = json['description'],
        isAvailable = json['isAvailable'],
        category = Food.toCategory(json['category'])!,
        image = Image.asset('assets/default_food.jpg' , package: 'models',)
  {
    id = json['ID'];
  }


  Map<String, dynamic> toJson() => {
    'ID' : id,
    'name' : name,
    'price' : price.toInt().toString(),
    'description' : description,
    'isAvailable' : isAvailable,
    'category' : category.toString(),
  };

  @override
  Server get server => _server;

  FoodData toFoodData() => FoodData(name, id!, price);

  // converts the result of [FoodCategory].toString() back to [FoodCategory]
  static FoodCategory? toCategory(String foodCategory) {
    for (var category in FoodCategory.values) {
      if (category.toString() == foodCategory) return category;
    }
    return null;
  }
}

enum FoodCategory {
  Iranian,
  FastFood,
  SeaFood
}