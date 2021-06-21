import 'editable.dart';
import 'serializable.dart';
import 'price.dart';
import 'server.dart';
import 'small_data.dart';
import 'package:flutter/material.dart';

class Food with Serializable implements Editable {

  String _name;
  Price _price;
  String _description;
  bool _isAvailable;
  FoodCategory _category;
  Server _server;
  Image _image;

  Food({
    required String name,
    required FoodCategory category,
    required Price price,
    Image? image,
    String? description,
    bool isAvailable = true,
    required Server server
  }) :
        _name = name,
        _category = category,
        _price = price,
        _image = image ?? Image.asset('assets/default_food.jpg' , package: 'models',),
        _description = description ?? '',
        _isAvailable = isAvailable,
        _server = server;

  Food.fromJson(Map<String, dynamic> json, Server server):
        _server = server,
        _name = json['name'],
        _price = Price(int.parse(json['price'])),
        _description = json['description'],
        _isAvailable = json['isAvailable'],
        _category = Food.toCategory(json['category'])!,
        _image = Image.asset('assets/default_food.jpg' , package: 'models',)
  {
    id = json['ID'];
  }


  Map<String, dynamic> toJson() => {
    'ID' : id,
    'name' : _name,
    'price' : _price.toInt().toString(),
    'description' : _description,
    'isAvailable' : _isAvailable,
    'category' : _category.toString(),
  };

  String get name => _name;

  Price get price => _price;

  String get description => _description;

  bool get isAvailable => _isAvailable;

  FoodCategory get category => _category;

  Image get image => _image;

  @override
  Server get server => _server;

  FoodData toFoodData() => FoodData(_name, id!, _price);

  set category(FoodCategory value) {
    _category = value;
    server.edit(this);
  }

  set isAvailable(bool value) {
    _isAvailable = value;
    server.edit(this);
  }

  set description(String value) {
    _description = value;
    server.edit(this);
  }

  set price(Price value) {
    _price = value;
    server.edit(this);
  }

  set name(String value) {
    _name = value;
    server.edit(this);
  }

  set image(Image image)
  {
    _image = image;
    server.edit(this);
  }

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