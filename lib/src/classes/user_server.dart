import 'dart:convert';
import 'editable.dart';
import 'server.dart';
import 'user_account.dart';
import 'order.dart';
import 'comment.dart';
import 'food.dart';
import 'small_data.dart';
import 'restaurant.dart';
import 'restaurant_predicate.dart';
import 'discount.dart';
import 'address.dart';

class UserServer extends Server {

  UserAccount? _account;

  UserAccount get account => _account!;

  @override
  String createMessage(List<String> commands) {
    commands.insert(0, 'user');
    return commands.join(separator);
  }

  @override
  Future<void> edit(Editable object) async {
    if (object is UserAccount) {
      //this should be saveAccount but address does the same thing
      await sendAndReceive(['address', account.phoneNumber, jsonEncode(object)]);
    } else {
      throw UnimplementedError('edit is not implemented for the type: ${object.runtimeType}.');
    }
  }

  @override
  Future<bool> login(String phoneNumber, String password) async {
    var response = await sendAndReceive(['login', phoneNumber, password]);
    if (response.contains('Error')) return false;
    _account = UserAccount.fromJson(jsonDecode(response), this);
    return true;
  }

  Future<void> addNewOrder(Order order) async {
    order.id = await serialize(order.runtimeType);
    await sendAndReceive(['order', account.phoneNumber, jsonEncode(account), order.id!, jsonEncode(order), order.restaurant.id!]);
  }

  Future<void> addNewComment(Comment comment) async {
    comment.id = await serialize(comment.runtimeType);
    account.commentIDs.add(comment.id!);
    await sendAndReceive(['comment', account.phoneNumber, jsonEncode(account), comment.restaurantID, comment.id!, jsonEncode(comment)]);
  }

  Future<Food?> getFoodByID(String foodID, String menuID) async {
    String message = await sendAndReceive(['getFood', menuID, foodID]);
    if (message.contains('Error')) return null;
    return Food.fromJson(jsonDecode(message), this);
  }

  Future<Order?> reorder(Order order) async {
    var newItems = <FoodData, int>{};
    for (var oldFoodData in order.items.keys) {
      var newFood = await getFoodByID(oldFoodData.foodID, order.restaurant.menuID!);
      if (newFood == null) continue;
      newItems[newFood.toFoodData()] = order.items[oldFoodData]!;
    }
    if (newItems.isEmpty) return null;
    var newOrder = Order(server: this, items: newItems, restaurant: order.restaurant, customer: order.customer);
    newOrder.id = await serialize(newOrder.runtimeType);
    return newOrder;
  }

  Future<List<Restaurant>> getRecommendedRestaurants() async {
    var message = await sendAndReceive(['recommended', 20.toString()]);
    return jsonDecode(message).map<Restaurant>((e) => Restaurant.fromJson(e)).toList();
  }

  Future<List<Restaurant>> filterRecommendedRestaurants(RestaurantPredicate predicate) async {
    var p = jsonEncode(predicate);
    var message = await sendAndReceive(['search', p]);
    return jsonDecode(message).map<Restaurant>((e) => Restaurant.fromJson(e)).toList();
  }

  List<Restaurant> sortRecommendedRestaurants(List<Restaurant> restaurants, int Function(Restaurant, Restaurant)? sortOrder) {
    if (sortOrder == null) {
      return restaurants;
    }
    restaurants.sort(sortOrder);
    return restaurants;
  }

  Future<Discount?> validateDiscount(String code) async {
    String message = await sendAndReceive(['discount', code]);
    if (message == 'null') return null;
    return Discount.fromJson(jsonDecode(message));
  }

  Future<void> useDiscount(Discount discount) async {
    await sendAndReceive(['useDiscount', discount.code]);
  }

  Future<bool> signUp(String firstName, String lastName, String phoneNumber, String password, Address defaultAddress) async {
    var acc = UserAccount(
      server: this,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      addresses: [defaultAddress],
      defaultAddressName: defaultAddress.name,
      favRestaurantIDs: [],
      commentIDs: [],
    );
    var response = await sendAndReceive(['signup', phoneNumber, password, jsonEncode(acc)]);
    if (response.contains('Error')) return false;
    _account = acc;
    return true;
  }

}