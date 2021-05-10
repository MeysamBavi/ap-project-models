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

      // restaurant app
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
      'order-page-active-orders' : 'Active Orders',
      'order-page-inactive-orders' : 'Previous Orders',
      'no-order-message' : 'No order exists.',
      'add-bottom-sheet-food-name' : 'Name',
      'add-bottom-sheet-food-price' : 'Price',
      'add-bottom-sheet-food-description' : 'Description',
      'add-food-empty-price-error' : 'Price is required.',
      'add-food-invalid-price-error' : 'Invalid number.',
      'add-food-empty-name-error' : 'Name is required.',
      'order-details-button' : 'Details',
      'menu-search-options-title' : 'Search for...',
      'search-name-hint' : 'Name contains...',
      'price-from' : 'Min price',
      'price-to' : 'Max price',
      'search-availability' : 'Is Available',
      'search' : 'Search',
      'settings-appbar-title' : 'Settings',
      'restaurant-name-label' : 'Restaurant name:',
      'restaurant-address-label' : 'Address:',
      'owner-phone-number-label' : 'Phone number:',
      'restaurant-score-label' : 'Score:',
      'restaurant-info-label' : 'Information:',
      'comment-button' : 'Comments',
      'map-button' : 'Set location',
      'place-marker-title' : 'Place the marker',
      'confirm' : 'Confirm',
      'aod-title' : 'Determine the area of dispatch',
      


      //user app
      'bottom-nav-restaurants' : 'Restaurants',
      'bottom-nav-cart' : 'Cart',
      'bottom-nav-orders' : 'Orders',
      'bottom-nav-user-account' : 'Account',
      'app-bar-restaurants' : 'Restaurants',
      'app-bar-leading-search' : 'Search',
      'restaurant-card-inf' : 'Buy',
      'restaurant-page-return-tooltip' : 'Return',
      'restaurant-page-menu-header' : 'Menu',
      'restaurant-page-button' : 'Info',
      'order-bottom-sheet-number' : 'Number',
      'order-bottom-sheet-empty-error' : 'Please enter a number',
      'order-bottom-sheet-negative-error' : 'Number must be positive',
      'order-bottom-sheet-order' : 'Order',
      'order-bottom-sheet-not-available' : 'This food is not available',
      'cart-page-no-items-in-cart' : 'The cart is empty',
      'cart-page-app-bar' : 'User cart',
      'cart-page-proceed' : 'Proceed',
      'cart-page-delete' : 'Delete',
      'user-account-app-bar' : 'User account',
      'add-fund-null-error' : 'The field cant be empty',
      'add-fund-negative-error' : 'Value cant be negative or zero',
      'add-fund-hint' : 'Add Credit',
      'fav-restaurants-app-bar' : 'Favourite Restaurants',
      'orders-app-bar' : 'Orders',

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

  static String formatDate(DateTime time) {
    var year = time.year.toString().padLeft(4, '0');
    var month = time.month.toString().padLeft(2, '0');
    var day = time.day.toString().padLeft(2, '0');
    var hour = time.hour.toString().padLeft(2, '0');
    var minute = time.minute.toString().padLeft(2, '0');
    var seconds = time.second.toString().padLeft(2, '0');
    return '$hour:$minute:$seconds  $year/$month/$day';
  }

  static String censorPhoneNumber(String phoneNumber) {
    var l = phoneNumber.length;
    return '${phoneNumber.substring(0, 4)}****${phoneNumber.substring(l-3, l)}';
  }

}