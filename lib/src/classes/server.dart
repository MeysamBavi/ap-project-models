import 'dart:convert';
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

  Future<void> edit(Editable object) async {
    if (object is Comment) {
      var response = await cs!.writeString(['owner', 'editComment', object.id, jsonEncode(object)].join(separator));
    } else if (object is Food) {
      var response = await cs!.writeString(['owner', 'editFood', (_account as OwnerAccount).restaurant.menuID, object.id, jsonEncode(object)].join(separator));
    } else if (object is FoodMenu) {
      var response = await cs!.writeString(['owner', 'save', object.id, jsonEncode(object)].join(separator));
    } else if (object is Order) {
      await refreshActiveOrders();
      _account!.activeOrders.remove(object);
      _account!.previousOrders.add(object);
      var response = await cs!.writeString([
        'owner',
        'deliver',
        object.id,
        jsonEncode(object),
        _account!.phoneNumber,
        jsonEncode(_account),
        jsonEncode((_account as OwnerAccount).activeOrdersToJson()),
      ].join(separator));
    } else if (object is UserAccount) {
      //this should be saveAccount but address does the same thing
      var response = await cs!.writeString(['user', 'address', _account!.phoneNumber, jsonEncode(object)].join(separator));
    }
  }

  Future<void> addFood(Food food) async {
    var response = await cs!.writeString(['owner', 'addFood', (_account as OwnerAccount).restaurant.menuID, food.id, jsonEncode(food)].join(separator));
  }

  Future<void> removeFood(Food food) async {
    var response = await cs!.writeString(['owner', 'removeFood', (_account as OwnerAccount).restaurant.menuID, food.id].join(separator));
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

  Future<void> refreshActiveOrders() async {
    var response = await cs!.writeString(['owner', 'activeOrders', _account!.phoneNumber].join(separator));
    _account!.activeOrders.clear();
    _account!.activeOrders.addAll(jsonDecode(response).map<Order>((e) => Order.fromJson(e, this)));
  }

  Future<void> editRestaurant() async {
    if (_account == null || _account is UserAccount) return;
    var restaurant = (_account as OwnerAccount).restaurant;
    var response = await cs!.writeString(['owner', 'editRestaurant', restaurant.id, jsonEncode(restaurant)].join(separator));
  }

  Future<void> addNewComment(Comment comment) async {
    comment.id = await cs!.writeString("user" + separator + "serialize" + separator + "comment");
    (_account as UserAccount).commentIDs.add(comment.id!);
    var message = ['user', 'comment', _account!.phoneNumber, jsonEncode(_account), comment.restaurantID, comment.id, jsonEncode(comment)].join(separator);
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

  Future<bool> login(String phoneNumber, String password, bool isForUser) async {
    if (isForUser) {
      var message ="user"  + separator + "login" + separator + phoneNumber + separator + password;
      String returnMessage = await cs!.writeString(message);
      if (returnMessage.startsWith("Error"))
        return false;
      _account = UserAccount.fromJson(jsonDecode(returnMessage), this);
    } else {
      var message = ['owner', 'login', phoneNumber, password].join(separator);
      String returnMessage = await cs!.writeString(message);
      if (returnMessage.startsWith("Error"))
        return false;
      _account = OwnerAccount.fromJson(jsonDecode(returnMessage), this);
      var restaurant = (_account as OwnerAccount).restaurant;
      restaurant.menu = (await getObjectByID<FoodMenu>(restaurant.menuID!)) as FoodMenu;
    }
    return true;
  }

  Future<bool> isPhoneNumberUnique(String phoneNumber) async {
    var message = await cs!.writeString(['user', 'isPhoneNumberUnique', phoneNumber].join(separator));
    return message == 'true' ? true : false;
  }

  Future<String> serialize(String type) async{
    return _account is UserAccount ?  await cs!.writeString("user" + separator + "serialize" + separator + type) : await cs!.writeString("owner" + separator + "serialize" + separator + type);
  }

  Future<bool> signUpOwner(String phoneNumber, String password, Restaurant restaurant, FoodMenu menu) async {
    var ownerAcc =  OwnerAccount(phoneNumber: phoneNumber, restaurant: restaurant, server: this);
    restaurant.menu = menu;
    restaurant.id = await cs!.writeString("owner" + separator + "serialize" + separator + "restaurant");
    var message = ("owner" + separator + "signup" + separator + phoneNumber + separator + password + separator +  jsonEncode(ownerAcc)+ separator + restaurant.id! + separator + jsonEncode(restaurant));
    String response = await cs!.writeString(message);
    var response2 = await cs!.writeString(['owner', 'save', menu.id, jsonEncode(menu)].join(separator));
    if (response == 'Error 3') return false;
    _account = ownerAcc;
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
    return true;
  }

  Future<Object?> getObjectByID<T>(String id) async {

    String userOrOwner = _account == null || _account is UserAccount ? 'user' : 'owner';

    if (T == FoodMenu) {
      String message = await cs!.writeString([userOrOwner, 'getMenu', id].join(separator));
      return FoodMenu.fromJson(jsonDecode(message), this);
    }

    String message = await cs!.writeString([userOrOwner, 'get', id].join(separator));
    switch (T) {
      case Order:
        return Order.fromJson(jsonDecode(message), this);
      case Restaurant:
        return Restaurant.fromJson(jsonDecode(message));
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
    var p = jsonEncode(predicate);
    var message = await cs!.writeString(['user', 'search', p].join(separator));
    print(message);
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