import 'package:flutter/material.dart';
import 'dart:math';
import '../classes/food.dart';

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
      'FoodCategory.FastFood' : 'Fast Food',
      'FoodCategory.SeaFood' : 'Sea Food',
      'FoodCategory.Iranian' : 'Iranian',

      'bottom-nav-label-stats' : 'Statistics',
      'bottom-nav-label-edit' : 'Edit Menu',
      'bottom-nav-label-order' : 'Orders',
      'edit-menu-categories-header' : 'Categories',
      'add-food-tooltip' : 'Add Food',
      'search-menu-tooltip' : 'Search Menu',
      'food-item-edit-button' : 'Edit',
      'toman' : 'Toman',
      'orders-menu-header' : 'Orders',
      'edit-bottom-sheet-remove' : 'Delete',
      'edit-bottom-sheet-save' : 'Save',
      'food-remove-dialog-title' : 'Delete Food?',
      'food-remove-dialog-no' : 'No',
      'food-remove-dialog-yes' : 'Yes',
      'remove-food-dialog-message' : 'Are you sure?',
      'order-bottom-sheet-is-ready' : 'ready to deliver?',
      'order-page-active-orders' : 'Active orders',
      'order-page-inactive-orders' : 'Inactive orders',
      'add-bottom-sheet-food-name' : 'Name',
      'add-bottom-sheet-food-price' : 'Price',
      'add-bottom-sheet-food-description' : 'Description',
      'add-food-empty-price-error' : 'Price is required.',
      'add-food-invalid-price-error' : 'Invalid number.',
      'add-food-empty-name-error' : 'Name is required.',
      'order-details-button' : 'Details',
    }
  };

  static String defaultLanguage = 'eng';

  static String? get(String key) {
    return _data[defaultLanguage]?[key];
  }

  static FoodCategory? toCategory(String name) {
    if (name == 'Iranian' || name == 'iranian') {
      return FoodCategory.Iranian;
    }
    if (name == 'Fast Food' || name == 'FastFood' || name == 'fast food') {
      return FoodCategory.FastFood;
    }
    if (name == 'Sea Food' || name == 'SeaFood' || name == 'sea food') {
      return FoodCategory.SeaFood;
    }
    return null;
  }
}