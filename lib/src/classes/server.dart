import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;
import 'custom_socket.dart';
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
import 'user_account.dart';
import 'restaurant_predicate.dart';

class Server {

  Server ([DataBase? dataBase]): this.dataBase = dataBase ?? DataBase.empty(), serializer = Serializer();
  Account? _account;
  DataBase dataBase;
  String token = '';
  final serializer;
  CustomSocket? cs;
  //Socket? socket;
  Account? get account => _account;
  String separator ="|*|*|";
  void setSocket(String ip , int port) async
  {
    cs = CustomSocket(ip , port);
  }

  static bool isPhoneNumberValid(String phoneNumber) {
    var pattern = RegExp(r'^09\d{9}$');
    return pattern.hasMatch(phoneNumber);
  }
  
  static bool isPasswordValid(String password) {
    var pattern = RegExp(r'^(?=.{6,}$)(?=.*[0-9])(?=.*[a-zA-Z])[0-9a-zA-Z]+$');
    return pattern.hasMatch(password);
  }

  void edit(Editable object) {
    //TODO implement edit
  }

  void addNewOrder(Order order) async {
    /*dataBase.orders.add(order);
    dataBase.ownerOf[order.restaurant.id!]!.activeOrders.add(order);*/
    //Custom socket version
    /*cs!.writeString("serialize" + separator + "order");
    order.id =await cs!.readString();
    _account!.activeOrders.add(order);
    cs!.writeString("order" + separator + _account!.phoneNumber + separator + (_account as UserAccount).toJson().toString() + separator + order.id! + separator + order.toJson().toString() + separator + order.restaurant.id!);
    */
    order.id = await cs!.writeString("user"+ separator  + "serialize" + separator + "order");
    var message = "user"  + separator + "order" + separator + _account!.phoneNumber + separator + jsonEncode(_account as UserAccount) + separator + order.id! + separator + jsonEncode(order) + separator + order.restaurant.id!;
    String response = await cs!.writeString(message);
    print(response);
  }
  

  void addNewComment(Comment comment) async {
    /*dataBase.comments.add(comment);
    var restaurant = getObjectByID(comment.restaurantID) as Restaurant;
    restaurant.commentIDs.add(comment.id!);*/
    //custom socket version
    /*cs!.writeString("serialize" + separator + "comment");
    comment.id = await cs!.readString();
    cs!.writeString("comment" + separator + _account!.phoneNumber + separator +(_account as UserAccount).toJson().toString() + separator + comment.id! + separator + comment.toJson().toString());
    */
    comment.id = await cs!.writeString("user" + separator + "serialize" + separator + "comment");
    var message = "user" + separator + "comment" + separator + _account!.phoneNumber + separator + jsonEncode(_account as UserAccount) + separator + comment.id! + separator + jsonEncode(comment);
    String response = await cs!.writeString(message);
    print(response);
  }
  
  //can be deleted !
  Future<Order?> reorder(Order order) async {
    var newItems = <FoodData, int>{};
    for (var oldFoodData in order.items.keys) {
      var newFood = await getFoodByID(oldFoodData.foodID, order.restaurant.menuID!);
      if (newFood == null) continue;
      newItems[newFood.toFoodData()] = order.items[oldFoodData]!;
    }
    if (newItems.isEmpty) return null;
    var newOrder = Order(server: this, items: newItems, restaurant: order.restaurant, customer: order.customer);
    newOrder.id = await cs!.writeString(['user', 'serialize', 'order'].join(separator));
    return newOrder;
  }

  Future<bool> login(String phoneNumber, String password, bool isForUser) async{
    /*var correctPassword = dataBase.loginData[phoneNumber];
    if (correctPassword == null) return false;
    if (password == correctPassword) {
      for (var acc in dataBase.accounts) {
        if (acc.phoneNumber == phoneNumber) {
          if (isForUser && acc is OwnerAccount) return false;
          if (!isForUser && acc is UserAccount) return false;

            _account = acc;
          // if this account is for owner, find and assign its restaurant's menu
          if (_account is OwnerAccount) {
            (_account as OwnerAccount).restaurant.menu = getObjectByID((_account as OwnerAccount).restaurant.menuID!) as FoodMenu;
          }
          return true;
        }
      }
    }
    return false;*/
    //custom socket version
    /*if (isForUser)
    {
        cs!.writeString("login"+separator + phoneNumber + separator + password);
        String accountJSON = await cs!.readString();
        if (!accountJSON.startsWith("Error")) {
          _account = UserAccount.fromJson(JsonDecoder().convert(accountJSON), this);
          return true;
        }
    }else{
      cs!.writeString("login"+separator+phoneNumber+separator+password);
      String? accountJSON = await cs!.readString();
      if (accountJSON != null)
      {
          _account = OwnerAccount.fromJson(JsonDecoder().convert(accountJSON), this);
          return true;
      }
    }
    return false;
     */
    if (isForUser) {
      var message ="user"  + separator + "login" + separator + phoneNumber + separator + password;
      String returnMessage = await cs!.writeString(message);
      if (returnMessage.startsWith("Error"))
        return false;
      _account = UserAccount.fromJson(jsonDecode(returnMessage), this);
    }else {
      var message ="owner"  + separator + "login" +separator + phoneNumber + separator + password;
      String returnMessage = await cs!.writeString(message);
      if (returnMessage.startsWith("Error"))
        return false;
      _account = OwnerAccount.fromJson(jsonDecode(returnMessage), this);
    }
    return true;
  }

  bool isPhoneNumberUnique(String phoneNumber) {
    if (!Server.isPhoneNumberValid(phoneNumber)) return true;
    for (var acc in dataBase.accounts) {
      if (acc.phoneNumber == phoneNumber) return false;
    }
    return true;
  }
  Future<String> serialize(String type) async{
    return _account is UserAccount ?  await cs!.writeString("user" + separator + "serialize" + separator + type) : await cs!.writeString("owner" + separator + "serialize" + separator + type);
  }
  Future<bool> signUpOwner(String phoneNumber, String password, Restaurant restaurant, FoodMenu menu) async {
    /*restaurant.serialize(serializer);
    restaurant.menu = menu;
    _account = OwnerAccount(phoneNumber: phoneNumber, restaurant: restaurant, server: this);
    dataBase.accounts.add(_account!);
    dataBase.loginData[phoneNumber] = password;
    dataBase.restaurants.add(restaurant);
    dataBase.menus.add(menu);*/
    //custom socket version
    /*cs!.writeString("serialize" + separator + "restaurant");
    restaurant.id = await cs!.readString();
    cs!.writeString("signup" + separator + phoneNumber + separator + password + ownerAcc.toJson().toString() + separator + restaurant.id! + separator + restaurant.toJson().toString());
    return true;*/
    var ownerAcc =  OwnerAccount(phoneNumber: phoneNumber, restaurant: restaurant, server: this);
    restaurant.menu = menu;
    restaurant.id = await cs!.writeString("owner" + separator + "serialize" + separator + "restaurant");
    var message = ("owner" + separator + "signup" + separator + phoneNumber + separator + password + separator +  jsonEncode(ownerAcc)+ separator + restaurant.id! + separator + jsonEncode(restaurant));
    String response = await cs!.writeString(message);
    if (response == 'false') return false;
    _account = ownerAcc;
    print(response);
    return true;
  }

  Future<bool> signUpUser(String firstName, String lastName, String phoneNumber, String password, Address defaultAddress) async {

    var account = UserAccount(
      server: this,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      addresses: [defaultAddress],
      defaultAddressName: defaultAddress.name,
      favRestaurantIDs: [],
      commentIDs: [],
    );
    var message ="user" + separator+"signup" + separator + phoneNumber + separator + password + separator + jsonEncode(account);
    String response = await cs!.writeString(message);
    if (response == 'false') return false;
    _account = account;
    print(response);
    return true;
  }

  Future<Object?> getObjectByID<T>(String id) async {

    String userOrOwner = _account is UserAccount ? 'user' : 'owner';

    String message = await cs!.writeString([userOrOwner, 'get', id].join(separator));
    switch (T) {
      case Order:
        return Order.fromJson(jsonDecode(message), this);
      case Restaurant:
        return Order.fromJson(jsonDecode(message), this);
      case FoodMenu:
        return FoodMenu.fromJson(jsonDecode(message), this);
      case Comment:
        return Comment.fromJson(jsonDecode(message), this);
    }
    return null;
  }

  Future<Food?> getFoodByID(String foodID, String menuID) async {
    String message = await cs!.writeString(['user', 'getFood', menuID, foodID].join(separator));
    if (message == 'null') return null;
    return Food.fromJson(jsonDecode(message), this);
  }

  static int onScore(Restaurant a, Restaurant b) => (b.score - a.score).sign.toInt();
  static int Function(Restaurant, Restaurant) createOnDistance(double latitude, double longitude) {
    return (Restaurant a, Restaurant b) {
      var distanceToA = Geolocator.distanceBetween(a.address.latitude, a.address.longitude, latitude, longitude);
      var distanceToB = Geolocator.distanceBetween(b.address.latitude, b.address.longitude, latitude, longitude);
      return (distanceToA - distanceToB).sign.toInt();
    };
  }

  Future<List<Restaurant>> getRecommendedRestaurants() async {
    var message = await cs!.writeString(['user', 'recommended', 20.toString()].join(separator));
    return jsonDecode(message).map<Restaurant>((e) => Restaurant.fromJson(e)).toList();
  }

  Future<List<Restaurant>> filterRecommendedRestaurants(RestaurantPredicate predicate) async {
    var message = await cs!.writeString(['user', 'search', jsonEncode(predicate)].join(separator));
    return jsonDecode(message).map<Restaurant>((e) => Restaurant.fromJson(e)).toList();
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

  Future<Discount?> validateDiscount(String code) async {
    String message = await cs!.writeString(['user', 'discount', code].join(separator));
    if (message == 'null') return null;
    return Discount.fromJson(jsonDecode(message));
  }

  void useDiscount(Discount discount) async {
    String message = await cs!.writeString(['user', 'useDiscount', discount.code].join(separator));
  }

}