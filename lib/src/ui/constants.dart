import 'package:flutter/material.dart';
import 'dart:math';

class CommonColors {
  static Color? pink = Colors.pink[200];
  static Color? blue = Colors.blueAccent[400];
  static Color? green = Colors.greenAccent[400];
  static Color? red = Colors.redAccent[400];
  static Color black = Colors.black;
  static Color cyan = Color(0xFF00E5FF);


  static var randomColorList = <Color?>[
    CommonColors.green,
    CommonColors.red,
    CommonColors.pink,
    CommonColors.cyan,
    CommonColors.blue,
  ];

  //random color generator method to be implemented
  static Color? generateColor() {
    Random rnd = new Random();
    return randomColorList[rnd.nextInt(randomColorList.length)];
  }
}

class Strings {

  static const _data = <String, Map<String, String>>{
    'eng' : {
      'key' : 'value',
      'bottom-nav-label-stats' : 'Statistics',
      'bottom-nav-label-edit' : 'Edit Menu',
      'bottom-nav-label-order' : 'Orders',
      'FoodCategory.FastFood' : 'Fast Food',
      'FoodCategory.SeaFood' : 'Sea Food',
      'FoodCategory.Iranian' : 'Iranian',
      'edit-menu-categories-header' : 'Categories',
      'add-food-tooltip' : 'Add Food',
      'search-menu-tooltip' : 'Search Menu',
      'food-item-edit-button' : 'Edit',
      'toman' : 'Toman',
    }
  };

  static String defaultLanguage = 'eng';

  static String? get(String key) {
    return _data[defaultLanguage]?[key];
  }
}