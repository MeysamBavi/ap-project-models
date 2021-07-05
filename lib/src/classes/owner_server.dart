import 'dart:convert';
import 'editable.dart';
import 'owner_account.dart';
import 'server.dart';
import 'food.dart';
import 'restaurant.dart';
import 'food_menu.dart';
import 'order.dart';
import 'comment.dart';

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
    } else if (object is FoodMenu) {
      await sendAndReceive(['save', object.id!, jsonEncode(object)]);
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
    return true;
  }

  Future<void> addFood(Food food) async {
    await sendAndReceive([restaurant.menuID!, food.id!, jsonEncode(food)]);
  }

  Future<void> removeFood(Food food) async {
    await sendAndReceive([restaurant.menuID!, food.id!]);
  }

  Future<void> refreshActiveOrders() async {
    var response = await sendAndReceive(['activeOrders', account.phoneNumber]);
    account.activeOrders.clear();
    account.activeOrders.addAll(jsonDecode(response).map<Order>((e) => Order.fromJson(e, this, account.restaurant)));
  }

  Future<void> editRestaurant() async {
    await sendAndReceive(['editRestaurant', restaurant.id!, jsonEncode(restaurant)]);
  }

  Future<bool> signUp(String phoneNumber, String password, Restaurant restaurant, FoodMenu menu) async {
    var ownerAcc =  OwnerAccount(phoneNumber: phoneNumber, restaurant: restaurant, server: this);
    restaurant.menu = menu;
    restaurant.id = await serialize(restaurant.runtimeType);
    var response = await sendAndReceive(['signup', phoneNumber, password, jsonEncode(ownerAcc), restaurant.id!, jsonEncode(restaurant)]);
    await sendAndReceive(['save', menu.id!, jsonEncode(menu)]);
    if (response.contains('Error')) return false;
    _account = ownerAcc;
    return true;
  }

}