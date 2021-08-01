import 'dart:math' show min;
import 'discount.dart';
import 'food.dart';
import 'owner_account.dart';
import 'restaurant_predicate.dart';
import 'user_account.dart';
import 'fake_data_base.dart';
import 'server.dart';
import 'user_server.dart';
import 'owner_server.dart';
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
    account.commentIDs.add(comment.id!);
    var restaurant = await getObjectByID<Restaurant>(comment.restaurantID);
    restaurant!.commentIDs.add(comment.id!);
  }

  @override
  Future<void> addNewOrder(Order order) async {
    order.id = await serialize(order.runtimeType);
    _dataBase.orders.add(order);
    setDeliveryTimeFor(order);
  }

  void setDeliveryTimeFor(Order order, [Duration? duration]) {
    if (duration == null) {
      duration = Duration(seconds: 15);
    }
    Future.delayed(duration, () {
      try {
        order.isDelivered = true;
      } on Error {}
    });
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
  Future<bool> signUp(String firstName, String lastName, String phoneNumber, String password, Address defaultAddress) async {
    _account = UserAccount(
      server: this,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      addresses: [defaultAddress],
      defaultAddressName: defaultAddress.name,
      favRestaurantIDs: [],
      commentIDs: [],
    );

    _dataBase.userAccounts.add(account);
    _dataBase.usersLoginData[phoneNumber] = password;
    return true;
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

//------------------------------------------

class FakeOwnerServer extends FakeServer implements OwnerServer {

  FakeOwnerServer({required DataBase dataBase}) : super(dataBase: dataBase);

  OwnerAccount? _account;

  @override
  OwnerAccount get account => _account!;

  @override
  Restaurant get restaurant => account.restaurant;

  @override
  Future<void> addFood(FoodMenu menu, Food food) async {}

  @override
  Future<void> editRestaurant() async {}

  @override
  Future<bool> login(String phoneNumber, String password) async {
    var correctPassword = _dataBase.ownersLoginData[phoneNumber];
    if (correctPassword == null) return false;
    if (password != correctPassword) return false;

    _account = _dataBase.ownerAccounts.firstWhere((element) => element.phoneNumber == phoneNumber);
    return true;
  }

  @override
  Future<void> logout() async {
    _account = null;
  }

  @override
  Future<void> refreshActiveOrders() async {}

  @override
  Future<void> removeFood(FoodMenu menu, Food food) async {}

  @override
  Future<bool> signUp({
    required String phoneNumber,
    required String password,
    required String name,
    required double areaOfDispatch,
    required Set<FoodCategory> categories,
    required Address address
  }) async {
    var menu = FoodMenu(this);
    menu.id = await serialize(menu.runtimeType);
    var restaurant = Restaurant(
        name: name,
        menuID: menu.id,
        score: 0.0,
        address: address,
        areaOfDispatch: areaOfDispatch,
        foodCategories: categories,
        numberOfComments: 0
    );
    var ownerAcc =  OwnerAccount(phoneNumber: phoneNumber, restaurant: restaurant, server: this);
    restaurant.menu = menu;
    restaurant.id = await serialize(restaurant.runtimeType);
    _account = ownerAcc;

    _dataBase.ownerAccounts.add(ownerAcc);
    _dataBase.ownersLoginData[phoneNumber] = password;
    _dataBase.ownerOf[restaurant.id!] = ownerAcc;
    _dataBase.restaurants.add(restaurant);
    _dataBase.menus.add(menu);
    return true;
  }

}