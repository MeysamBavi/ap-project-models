import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
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
    var message = "user"  + separator + "order" + separator + _account!.phoneNumber + separator + (_account as UserAccount).toJson().toString() + separator + order.id! + separator + order.toJson().toString() + separator + order.restaurant.id!;
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
    var message = "user" + separator + "comment" + separator + _account!.phoneNumber + separator +(_account as UserAccount).toJson().toString() + separator + comment.id! + separator + comment.toJson().toString();
    String response = await cs!.writeString(message);
    print(response);
  }
  
  //can be deleted !
  Order? reorder(Order order) {
    /*var newItems = <FoodData, int>{};
    for (var oldFoodData in order.items.keys) {
      var newFood = getFoodByID(oldFoodData.foodID, order.restaurant.menuID!);
      if (newFood == null) continue;
      newItems[newFood.toFoodData()] = order.items[oldFoodData]!;
    }
    if (newItems.isEmpty) return null;
    var newOrder = Order(server: this, items: newItems, restaurant: order.restaurant, customer: order.customer);
    newOrder.serialize(serializer);
    return newOrder;*/

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
    if (isForUser){
      var message ="user"  + separator + "login" +separator + phoneNumber + separator + password;
      String returnMessage = await cs!.writeString(message);
      if (returnMessage.startsWith("Error"))
        return false;
      _account = UserAccount.fromJson(json.decode(returnMessage), this);
    }else {
      var message ="owner"  + separator + "login" +separator + phoneNumber + separator + password;
      String returnMessage = await cs!.writeString(message);
      if (returnMessage.startsWith("Error"))
        return false;
      _account = OwnerAccount.fromJson(json.decode(returnMessage), this);
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
    restaurant.id = await cs!.writeString("owner" + separator + "serialize" + separator + "restaurant");
    var message = "owner" + separator + "signup" + separator + phoneNumber + separator + password +  ownerAcc.toJson().toString() + separator + restaurant.id! + separator + restaurant.toJson().toString();
    String response = await cs!.writeString(message);
    _account = ownerAcc;
    print(response);
    return true;
  }

  Future<bool> signUpUser(String firstName, String lastName, String phoneNumber, Address defaultAddress) async {

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
    //custom socket version
    /*
    cs!.writeString("user");
    cs!.writeString("signup" + separator + phoneNumber + separator +/*has to be password*/ "sinaTaheri1" + separator + account.toJson().toString());
    print("Signup" + separator + phoneNumber + separator + "sinaTaheri1" + separator + account.toJson().toString());
    _account = account;
    return true;*/
    var message ="user" + separator+"signup" + separator + phoneNumber + separator +/*has to be password*/ "sinaTaheri1" + separator + account.toJson().toString();
    String response = await cs!.writeString(message);
    _account = account;
    print(response);
    return true;
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

  List<int> intToBytes(int value)
  {
    return [(value & 0xFF000000) >> 24 , (value & 0x00FF0000) >> 16 , (value & 0x0000FF00) >> 8 , value & 0x000000FF];
  }
}