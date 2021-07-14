import 'dart:math';
import 'dart:convert';
import 'fake_server.dart';
import 'food_menu.dart';
import 'food.dart';
import 'account.dart';
import 'owner_account.dart';
import 'user_account.dart';
import 'order.dart';
import 'restaurant.dart';
import 'comment.dart';
import 'price.dart';
import 'server.dart';
import 'small_data.dart';
import 'address.dart';
import 'discount.dart';
import 'server.dart';

class DataBase {
  final List<UserAccount> userAccounts;
  final List<OwnerAccount> ownerAccounts;
  final List<Restaurant> restaurants;
  final List<Comment> comments;
  final List<FoodMenu> menus;
  final List<Order> orders;
  final List<Discount> discounts;
  final Map<String, String> ownersLoginData;
  final Map<String, String> usersLoginData;
  final Map<String, OwnerAccount> ownerOf;

  DataBase({
    required this.ownerAccounts,
    required this.userAccounts,
    required this.restaurants,
    required this.comments,
    required this.menus,
    required this.orders,
    required this.ownersLoginData,
    required this.usersLoginData,
    required this.ownerOf,
    required this.discounts
});

  factory DataBase.empty() => DataBase(
    ownerAccounts: [],
    userAccounts: [],
    comments: [],
    restaurants: [],
    menus: [],
    orders: [],
    ownersLoginData: {},
    usersLoginData: {},
    ownerOf: {},
    discounts: [],
  );

}

class FakeData {

  FakeData._();
  static FakeData _fakeData = FakeData._();
  factory FakeData() => _fakeData;

  DataBase createFakeUserDataBase(FakeUserServer server) {
    var db = DataBase.empty();

    var user =  UserAccount(
      phoneNumber: "09000111222",
      firstName: "Ali",
      lastName: "Alavi",
      addresses: [Address(latitude: 35.76053415, longitude: 51.39420474, name: 'Home', text: 'Tehran - Vanak - Sheykh Bahayi St')],
      defaultAddressName: 'Home',
      commentIDs: [],
      favRestaurantIDs: [],
      server: server,
    );
    db.userAccounts.add(user);
    db.usersLoginData["09000111222"] = "password1";
    
    return db;
  }
}