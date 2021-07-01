import 'package:flutter/material.dart';
import 'dart:math';
import '../classes/food.dart';

class CommonColors {
  static Color? pink = Colors.pink[200];
  static Color? blue = Colors.blueAccent[400];
  static Color? green = Colors.greenAccent[400];
  static Color? red = Colors.redAccent[400];
  static const Color black = Colors.black;
  static const Color cyan = Color(0xFF00E5FF);

  static const Color themeColorPlatinum = Color(0xFFE7E5DF);
  static const Color themeColorPlatinumLight = Color(0xFFFFFDF7);
  static const Color themeColorBlue = Color(0xFF44BBA4);
  static const Color themeColorBlueDark = Color(0xFF378F7D);
  static const Color themeColorRed = Color(0xFFBD2426);
  static const Color themeColorRed2 = Color(0xFF980000);
  static const Color themeColorBlack = Color(0xFF393E41);
  static const Color themeColorYellow = Color(0xFFE7BB41);
  static const Color themeColorYellowDark = Color(0xFFCCA12B);

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
      'owner-phone-number-label' : 'Phone number',
      'restaurant-score-label' : 'Score:',
      'restaurant-info-label' : 'Information',
      'comment-button' : 'Comments',
      'map-button' : 'Set location',
      'place-marker-title' : 'Place the marker',
      'confirm' : 'Confirm',
      'aod-title' : 'Determine the area of dispatch',
      'comments-panel-title' : 'Comments',
      'stats-title' : 'Statistics',
      'today' : 'Today',
      'all' : 'All',
      'edit-add-image' : 'Edit image',
      'account' : 'Account',
      'logo-label' : 'Restaurant logo:',
      'settings-categories' : 'Food Categories',
      'address-tile' : 'Address and area of dispatch',
      'address-text-title' : 'Text',
      'coordinates' : 'Coordinates',
      'edit-address' : 'Edit',
      'area-radius' : 'Radius',
      'save-address' : 'Save',
      'sign-up-header' : 'Create an account',
      'sign-up-button' : 'Sign Up',
      'restaurant-name-empty' : 'Name is required.',
      'restaurant-address-text-hint' : 'Address description',
      'address-text-empty' : 'Address is required.',
      'coordinates-empty' : 'Coordinates are required.',
      'radius-empty' : 'Radius is required.',
      'set-radius-and-coordinates' : 'Set',
      'duplicate-number-error' : 'This phone number is already registered.',
      'login-prompt' : 'Already have an account?',

      //user app
      'bottom-nav-restaurants' : 'Restaurants',
      'bottom-nav-cart' : 'Cart',
      'bottom-nav-orders' : 'Orders',
      'bottom-nav-user-account' : 'Account',
      'app-bar-restaurants' : 'Restaurants',
      'app-bar-leading-search' : 'Search',
      'restaurant-card-inf' : 'Buy',
      'restaurant-page-return-tooltip' : 'Return',
      'restaurant-page-accept-tooltip' : 'Order',
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
      'add-fund-null-error' : 'The field can\'t be empty',
      'add-fund-negative-error' : 'Enter a positive value.',
      'add-fund-invalid-number' : 'Invalid number.',
      'account-info-title' : 'Account Info',
      'firstname' : 'First name',
      'lastname' : 'Last name',
      'phone-number' : 'Phone number',
      'add-fund-hint' : 'Add Credit',
      'my-comments-title' : 'My Comments',
      'fav-restaurants-app-bar' : 'Favourite Restaurants',
      'addressed-title' : 'Addresses',
      'set-default-address' : 'Set as default address',
      'address-actions-hint' : 'Tap to edit. Hold to set as default',
      'orders-app-bar' : 'Orders',
      'orders-active-orders-heading' : 'Active Orders',
      'orders-previous-orders-heading' : 'Previous Orders',
      'orders-no-active-orders' : 'No Active Orders',
      'orders-no-previous-orders' : 'No Previous Orders',
      'orders-reorder-button' : 'Re-Order',
      'insufficient-fund-dialog' : 'Not Enough Money',
      'current-credit-message' : 'You currently have',
      'fund-dialog-add-fund' : 'Add',
      'orders-comment-button' : 'Comment',
      'my-comments' : 'My Comments',
      'no-comments' : 'You haven\'t commented anything.',
      'comment-title' : 'Title',
      'comment-message' : 'Message',
      'comment-empty-title' : 'Title can\'t be empty.',
      'comment-empty-message' : 'Message can\'t be empty.',
      'reorder-fail' : 'Could not recreate the order.',
      'reorder-success' : 'Order added to your cart.',
      'search-name-empty' : 'Name is required.',
      'restaurant-name-hint' : 'Restaurant name',
      'restaurant-no-comments' : 'No comment found.',
      'comments-tab-title' : 'Comments',
      'edit-address-title' : 'Edit Address',
      'add-address-title' : 'Add Address',
      'address-name-hint' : 'Address name',
      'address-text-hint' : 'Full description',
      'address-coordinates-hint' : 'Coordinates',
      'empty-address-name' : 'Name is required.',
      'empty-address-text' : 'Description can\'t be empty.',
      'empty-address-coordinates' : 'Coordinates are required.',
      'done' : 'Done',
      'ok' : 'Ok',
      'outside-area-dialog-title' : 'Outside of area of dispatch',
      'outside-area-dialog-message' : 'Your default address is outside of this restaurant\'s area. Choose a different address.',
      'discount-button' : 'Apply Discount',
      'discount-dialog-title' : 'Enter discount code:',
      'discount-invalid-code' : 'Invalid discount code.',
      'apply' : 'Apply',
      'signup-address-hint' : 'Tap here to add address',
      'first-name-hint' : 'First name',
      'last-name-hint' : 'Last name',
      'empty-first-name' : 'First name is required.',
      'empty-last-name' : 'Last name is required.',

      //models
      'empty-reply-error' : 'Reply can\'t be empty',
      'in-area' : 'Inside area',
      'not-in-area' : 'Outside area',
      'phone-number-hint' : 'Phone number',
      'phone-number-empty' : 'Phone number is required.',
      'phone-number-invalid' : 'Invalid phone number.',
      'password-hint' : 'Password',
      'password-empty' : 'Password is required.',
      'password-invalid' : 'Invalid password.',
      'password-helper' : 'At least 6 characters of letters and numbers.',
      'no-accounts-found' : 'Phone number or password is wrong.',
      'login-button' : 'Login',
      'login-header' : 'Login to your account',
      'sign-up-prompt' : 'Don\'t have an account?',

      //user snack bars
      'foods-added-to-cart' : 'Your orders have been added to the cart',
      'order-completed' : 'Order is complete, your food will be delivered ASAP',
      'credit-added' : 'Credit added Successfully',
      'comment-added' : 'Comment added Successfully',
      'delete_order' : 'Order deleted Successfully',
      'address-added' : 'Address added successfully.',
      'address-edited' : 'Address edited successfully.',

      //restaurant snack bars
      'edit-food-edit-successful' : 'Food edited Successfully',
      'delete-food-successful' : 'Food deleted Successfully',
      'add-food-successful' : 'Food added Successfully',
      'food-delivered-successful' : 'Food delivered Successfully',
      'comment-answer-added' : 'Your answer has been added to the Comment',
      'location-selected' : 'Area of dispatch Selected Successfully',

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
    var hour = time.hour.toString().padLeft(2, '0');
    var minute = time.minute.toString().padLeft(2, '0');
    var seconds = time.second.toString().padLeft(2, '0');
    return '$hour:$minute:$seconds  ${formatDay(time)}';
  }

  static String formatDay(DateTime time) {
    var year = time.year.toString().padLeft(4, '0');
    var month = time.month.toString().padLeft(2, '0');
    var day = time.day.toString().padLeft(2, '0');
    return '$year/$month/$day';
  }

  static String censorPhoneNumber(String phoneNumber) {
    var l = phoneNumber.length;
    return '${phoneNumber.substring(0, 4)}****${phoneNumber.substring(l-3, l)}';
  }

}