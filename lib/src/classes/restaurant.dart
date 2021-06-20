import 'food.dart';
import 'food_menu.dart';
import 'serializable.dart';
import 'address.dart';
import 'package:flutter/material.dart';

class Restaurant with Serializable {
  final String name;
  FoodMenu? menu;
  final String? menuID;
  final Set<FoodCategory> foodCategories;
  Address address;
  double areaOfDispatch; // in meters
  final double score;
  final List<String> commentIDs;
  Image logo;


  Restaurant({
    required this.name,
    Set<FoodCategory>? foodCategories,
    required this.menuID,
    required this.score,
    required this.address,
    Image? logo,
    this.areaOfDispatch = 0,
  })  : commentIDs = [],
        this.logo = logo??Image.asset('assets/default_restaurant.jpg' , package: 'models',),
        this.foodCategories = foodCategories ?? {};

  Map<String, dynamic> toJson() => {
    'ID' : id,
    'name' : name,
    'menuID' : menuID,
    'foodCategories' : foodCategories.map((e) => e.toString()).toList(growable: false),
    'address' : address,
    'areaOfDispatch' : areaOfDispatch,
    'score' : score,
    'commentIDs' : commentIDs,
  };

}