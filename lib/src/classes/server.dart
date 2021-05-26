import 'dart:math';
import 'package:geolocator/geolocator.dart' show Geolocator;
import 'fake_data_base.dart';
import 'order.dart';
import 'editable.dart';
import 'serializer.dart';
import 'account.dart';
import 'owner_account.dart';
import 'food_menu.dart';
import 'small_data.dart';
import 'food.dart';
import 'restaurant.dart';
import 'comment.dart';
import 'address.dart';
import 'discount.dart';

class Server {

  Server([DataBase? dataBase]) : this.dataBase = dataBase ?? DataBase.empty(), serializer = Serializer();

  Account? _account;
  DataBase dataBase;
  String token = '';
  final serializer;

  Account? get account => _account;

  bool isPhoneNumberValid(String phoneNumber) {
    var pattern = RegExp(r'^09\d{9}$');
    return pattern.hasMatch(phoneNumber);
  }
  
  bool isPasswordValid(String password) {
    var pattern = RegExp(r'^(?=.{6,}$)(?=.*[0-9])(?=.*[a-zA-Z])[0-9a-zA-Z]+$');
    return pattern.hasMatch(password);
  }

  void edit(Editable object) {
    //TODO implement edit
  }

  void addNewOrder(Order order) {
    dataBase.orders.add(order);
    dataBase.ownerOf[order.restaurant.id!]!.activeOrders.add(order);
  }

  void addNewComment(Comment comment) {
    dataBase.comments.add(comment);
    var restaurant = getObjectByID(comment.restaurantID) as Restaurant;
    restaurant.commentIDs.add(comment.id!);
  }

  Order? reorder(Order order) {
    var newItems = <FoodData, int>{};
    for (var oldFoodData in order.items.keys) {
      var newFood = getFoodByID(oldFoodData.foodID, order.restaurant.menuID!);
      if (newFood == null) continue;
      newItems[newFood.toFoodData()] = order.items[oldFoodData]!;
    }
    if (newItems.isEmpty) return null;
    var newOrder = Order(server: this, items: newItems, restaurant: order.restaurant, customer: order.customer);
    newOrder.serialize(serializer);
    return newOrder;
  }

  bool login(String phoneNumber, String password) {
    var correctPassword = dataBase.loginData[phoneNumber];
    if (correctPassword == null) return false;
    if (password == correctPassword) {
      for (var acc in dataBase.accounts) {
        if (acc.phoneNumber == phoneNumber) {
          _account = acc;
          // if this account is for owner, fina and assign its restaurant's menu
          if (_account is OwnerAccount) {
            (_account as OwnerAccount).restaurant.menu = getObjectByID((_account as OwnerAccount).restaurant.menuID!) as FoodMenu;
          }
          return true;
        }
      }
    }
    return false;
  }

  Object? getObjectByID(String id) {
    if (!serializer.isIDValid(id)) {
      print('INVALID ID');
      return null;
    }

    if (id.startsWith('M-')) {
      for (var menu in dataBase.menus) {
        if (menu.id == id) return menu;
      }
    }

    if (id.startsWith('R-')) {
      for (var res in dataBase.restaurants) {
        if (res.id == id) return res;
      }
    }

    if (id.startsWith('C-')) {
      for (var comment in dataBase.comments) {
        if (comment.id == id) return comment;
      }
    }

    if (id.startsWith('O-')) {
      for (var order in dataBase.orders) {
        if (order.id == id) return order;
      }
    }
    return null;
  }

  Food? getFoodByID(String foodID, String menuID) {
    if (!serializer.isIDValid(foodID)) return null;
    var menu = getObjectByID(menuID) as FoodMenu?;
    if (menu == null) return null;
    for (var cat in menu.categories) {
      var foods = menu.getFoods(cat)!;
      for (var food in foods) {
        if (food.id == foodID) return food;
      }
    }
    return null;
  }

  static int onScore(Restaurant a, Restaurant b) => (b.score - a.score).sign.toInt();
  static int Function(Restaurant, Restaurant) createOnDistance(double latitude, double longitude) {
    return (Restaurant a, Restaurant b) {
      var distanceToA = Geolocator.distanceBetween(a.address.latitude, a.address.longitude, latitude, longitude);
      var distanceToB = Geolocator.distanceBetween(b.address.latitude, b.address.longitude, latitude, longitude);
      return (distanceToA - distanceToB).sign.toInt();
    };
  }

  List<Restaurant> getRecommendedRestaurants(bool Function(Restaurant)? filter) {
    List<Restaurant> result;
    if (filter == null) {
      result = dataBase.restaurants.sublist(0, min(10, dataBase.restaurants.length));
      return result;
    }
    result = dataBase.restaurants.where(filter).toList(growable: false);
    return result;
  }

  List<Restaurant> sortRecommendedRestaurants(List<Restaurant> restaurants, int Function(Restaurant, Restaurant)? sortOrder) {
    if (sortOrder == null) {
      return restaurants;
    }
    restaurants.sort(sortOrder);
    return restaurants;
  }

  bool isInArea(Address customer, Address restaurant, double radius) {
    if (radius == 0.0) return true;
    return Geolocator.distanceBetween(restaurant.latitude, restaurant.longitude, customer.latitude, customer.longitude) <= radius;
  }

  Discount? validateDiscount(String code) {
    var index =  dataBase.discounts.indexWhere((element) => element.code == code);
    return index > -1 ? dataBase.discounts[index] : null;
  }

  void useDiscount(Discount discount) {
    dataBase.discounts.remove(discount);
  }

}