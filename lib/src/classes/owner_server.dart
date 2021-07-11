import 'dart:convert';
import 'editable.dart';
import 'owner_account.dart';
import 'server.dart';
import 'food.dart';
import 'restaurant.dart';
import 'food_menu.dart';
import 'order.dart';
import 'comment.dart';
import 'address.dart';

class OwnerServer extends Server {

  OwnerAccount? _account;

  OwnerAccount get account => _account!;

  Restaurant get restaurant => account.restaurant;

  @override
  String createMessage(List<String> commands) {
    commands.insert(0, 'owner');
    return commands.join(separator);
  }

  @override
  Future<void> edit(Editable object) async {
    if (object is Comment) {
      await sendAndReceive(['editComment', object.id!, jsonEncode(object)]);
    } else if (object is Food) {
      await sendAndReceive(['editFood', restaurant.menuID!, object.id!, jsonEncode(object)]);
    } else if (object is Order) {
      await refreshActiveOrders();
      account.activeOrders.remove(object);
      account.previousOrders.add(object);
      await sendAndReceive([
        'deliver',
        object.id!,
        jsonEncode(object),
        account.phoneNumber,
        jsonEncode(account),
        jsonEncode(account.activeOrdersToJson()),
      ]);
    } else {
      throw UnimplementedError('edit is not implemented for the type: ${object.runtimeType}.');
    }
  }

  @override
  Future<bool> login(String phoneNumber, String password) async {
    var response = await sendAndReceive(['login', phoneNumber, password]);
    if (response.contains('Error')) return false;
    _account = OwnerAccount.fromJson(jsonDecode(response), this);
    restaurant.menu = await getObjectByID<FoodMenu>(restaurant.menuID!);
    return true;
  }

  Future<void> removeFood(FoodMenu menu, Food food) async {
    await sendAndReceive(['removeFood', menu.id!, food.id!, jsonEncode(menu)]);
  }

  Future<void> addFood(FoodMenu menu, Food food) async {
    await sendAndReceive(['addFood', menu.id!, jsonEncode(menu), food.id!, jsonEncode(food)]);
  }

  Future<void> refreshActiveOrders() async {
    var response = await sendAndReceive(['activeOrders', account.phoneNumber]);
    account.activeOrders.clear();
    account.activeOrders.addAll(jsonDecode(response).map<Order>((e) => Order.fromJson(e, this, account.restaurant)));
  }

  Future<void> editRestaurant() async {
    await sendAndReceive(['editRestaurant', restaurant.id!, jsonEncode(restaurant)]);
  }

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
    );
    var ownerAcc =  OwnerAccount(phoneNumber: phoneNumber, restaurant: restaurant, server: this);
    restaurant.menu = menu;
    restaurant.id = await serialize(restaurant.runtimeType);
    var response = await sendAndReceive(['signup', phoneNumber, password, jsonEncode(ownerAcc), restaurant.id!, jsonEncode(restaurant), menu.id!, jsonEncode(menu)]);
    if (response.contains('Error')) return false;
    _account = ownerAcc;
    return true;
  }

}