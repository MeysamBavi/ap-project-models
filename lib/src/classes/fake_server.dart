import 'package:models/src/classes/discount.dart';

import 'package:models/src/classes/food.dart';

import 'package:models/src/classes/restaurant_predicate.dart';

import 'package:models/src/classes/user_account.dart';
import 'dart:math';
import 'fake_data_base.dart';
import 'server.dart';
import 'user_server.dart';
import 'owner_server.dart';
import 'food.dart';
import 'small_data.dart';
import 'food_menu.dart';
import 'restaurant.dart';
import 'address.dart';
import 'comment.dart';
import 'order.dart';
import 'editable.dart';
import 'serializer.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;

abstract class FakeServer implements Server {

  DataBase _dataBase;

  FakeServer({required DataBase dataBase})  : _dataBase = dataBase;

  @override
  bool isInArea(Address customer, Address restaurant, double radius) {
    if (radius == 0.0) return true;
    return Geolocator.distanceBetween(restaurant.latitude, restaurant.longitude, customer.latitude, customer.longitude) <= radius;
  }

  @override
  Future<T?> getObjectByID<T>(String id) async {
    if (T == dynamic) {
      throw Exception('Object type can\'t be dynamic.');
    }
    if (id.startsWith('M-')) {
      for (var menu in _dataBase.menus) {
        if (menu.id == id) return menu as T;
      }
    }

    if (id.startsWith('R-')) {
      for (var res in _dataBase.restaurants) {
        if (res.id == id) return res as T;
      }
    }

    if (id.startsWith('C-')) {
      for (var comment in _dataBase.comments) {
        if (comment.id == id) return comment as T;
      }
    }

    if (id.startsWith('O-')) {
      for (var order in _dataBase.orders) {
        if (order.id == id) return order as T;
      }
    }
    return null;
  }

  @override
  Future<bool> isPhoneNumberUnique(String phoneNumber) async {
    for (var acc in _dataBase.userAccounts) {
      if (acc.phoneNumber == phoneNumber) return false;
    }
    for (var acc in _dataBase.ownerAccounts) {
      if (acc.phoneNumber == phoneNumber) return false;
    }
    return true;
  }

  @override
  Future<String> serialize(Type type) async {
    return Serializer().createID(type);
  }

  @override
  Future<void> edit(Editable editable) async {}

  //methods below should not get called when using this offline server

  @override
  String createMessage(List<String> commands) {
    throw UnimplementedError();
  }

  @override
  String? get ip => throw UnimplementedError();

  @override
  Future<int?> get ping => throw UnimplementedError();

  @override
  int? get port => throw UnimplementedError();

  @override
  Future<String> sendAndReceive(List<String> commands) {
    throw UnimplementedError();
  }

  @override
  String get separator => throw UnimplementedError();

  @override
  void setSocket(String ip, int port) {
    throw UnimplementedError();
  }
}

//------------------------------------------

class FakeUserServer extends FakeServer implements UserServer {

  UserAccount? _account;

  FakeUserServer({required DataBase dataBase})  : super(dataBase: dataBase);

  @override
  UserAccount get account => _account!;

  @override
  Future<void> addNewComment(Comment comment) async {
    comment.id = await serialize(comment.runtimeType);
    _dataBase.comments.add(comment);
    var restaurant = await getObjectByID<Restaurant>(comment.restaurantID);
    restaurant!.commentIDs.add(comment.id!);
  }

  @override
  Future<void> addNewOrder(Order order) async {
    order.id = await serialize(order.runtimeType);
    _dataBase.orders.add(order);
    _dataBase.ownerOf[order.restaurant.id!]!.activeOrders.add(order);
  }

  @override
  Future<List<Restaurant>> filterRecommendedRestaurants(RestaurantPredicate predicate) async {
    var filter = predicate.generate();
    return _dataBase.restaurants.where(filter).toList();
  }

  @override
  Future<Food?> getFoodByID(String foodID, String menuID) async {
    var menu = await getObjectByID<FoodMenu>(menuID);
    if (menu == null) return null;
    for (var category in menu.categories) {
      var foods = menu.getFoods(category)!;
      for (var food in foods) {
        if (food.id == foodID) return food;
      }
    }
    return null;
  }

  @override
  Future<List<Restaurant>> getRecommendedRestaurants() async {
    return _dataBase.restaurants.sublist(0, min(20, _dataBase.restaurants.length));
  }

  @override
  Future<bool> login(String phoneNumber, String password) async {
    var correctPassword = _dataBase.usersLoginData[phoneNumber];
    if (correctPassword == null) return false;
    if (password != correctPassword) return false;

    _account = _dataBase.userAccounts.firstWhere((element) => element.phoneNumber == phoneNumber);
    return true;
  }

  @override
  Future<void> logout() async {
    _account = null;
  }

  @override
  Future<Order?> reorder(Order order) async {
    var newItems = <FoodData, int>{};
    order.items.forEach((key, value) => newItems[key] = value);
    var newOrder = Order(server: this, items: newItems, restaurant: order.restaurant, customer: order.customer);
    newOrder.id = await serialize(newOrder.runtimeType);
    return newOrder;
  }

  @override
  Future<bool> signUp(String firstName, String lastName, String phoneNumber, String password, Address defaultAddress) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  List<Restaurant> sortRecommendedRestaurants(List<Restaurant> restaurants, int Function(Restaurant p1, Restaurant p2)? sortOrder) {
    if (sortOrder != null) {
      restaurants.sort(sortOrder);
    }
    return restaurants;
  }

  @override
  Future<void> useDiscount(Discount discount) async {
    _dataBase.discounts.remove(discount);
  }

  @override
  Future<Discount?> validateDiscount(String code) async {
    var index =  _dataBase.discounts.indexWhere((element) => element.code == code);
    return index > -1 ? _dataBase.discounts[index] : null;
  }

}