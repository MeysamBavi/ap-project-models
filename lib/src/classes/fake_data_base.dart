import 'dart:math';
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

class DataBase {
  final List<Account> accounts;
  final List<Restaurant> restaurants;
  final List<Comment> comments;
  final List<FoodMenu> menus;
  final List<Order> orders;
  final Map<String, String> loginData;
  final Map<String, OwnerAccount> ownerOf;

  DataBase({
  required this.accounts,
  required this.restaurants,
  required this.comments,
  required this.menus,
  required this.orders,
  required this.loginData,
  required this.ownerOf
});

  static DataBase empty() {
    return DataBase(accounts: [], restaurants: [], comments: [], menus: [], orders: [], loginData: {}, ownerOf: {});
  }

}

class FakeData {

  final DataBase dataBase;
  final Server server;
  final rand = Random(DateTime.now().second);

  final List<Food> foods;

  FakeData(this.server)  : dataBase = server.dataBase,
        foods = <Food>[
    Food(name: 'Pepperoni', category: FoodCategory.FastFood, price: Price(35000), server: server, isAvailable: false),
    Food(name: 'Sushi', category: FoodCategory.SeaFood, price: Price(50000), server: server),
    Food(name: 'Fish', category: FoodCategory.SeaFood, price: Price(30000), server: server),
    Food(name: 'Kabab', category: FoodCategory.Iranian, price: Price(20000), server: server),
    Food(name: 'Fired Chicken', category: FoodCategory.FastFood, price: Price(45000), server: server),
    Food(name: 'Lasagna', category: FoodCategory.FastFood, price: Price(23000), server: server),
    Food(name: 'Pasta', category: FoodCategory.FastFood, price: Price(27000), server: server),
    Food(name: 'Qeyme', category: FoodCategory.Iranian, price: Price(20000), server: server),
    Food(name: 'Sardine', category: FoodCategory.SeaFood, price: Price(12000), server: server, isAvailable: false),
    Food(name: 'Eggs', category: FoodCategory.Iranian, price: Price(5000), server: server),
    Food(name: 'Burger', category: FoodCategory.FastFood, price: Price(32000), server: server),
    Food(name: 'Taco', category: FoodCategory.FastFood, price: Price(94000), server: server),
    Food(name: 'Salsa', category: FoodCategory.FastFood, price: Price(43000), server: server),
    Food(name: 'Jooje', category: FoodCategory.Iranian, price: Price(17000), server: server, isAvailable: false),
    Food(name: 'Tuna', category: FoodCategory.SeaFood, price: Price(28000), server: server, isAvailable: false),
    Food(name: 'Shark', category: FoodCategory.SeaFood, price: Price(88000), server: server),
    Food(name: 'Mirza Qasemi', category: FoodCategory.Iranian, price: Price(48000), server: server),
    Food(name: 'Sabzi Polo', category: FoodCategory.Iranian, price: Price(59000), server: server, isAvailable: false),
    Food(name: 'Kalam Polo', category: FoodCategory.Iranian, price: Price(14000), server: server),
    Food(name: 'Barg', category: FoodCategory.Iranian, price: Price(53000), server: server),
  ] {
    foods.forEach((element) => element.serialize(server.serializer));
  }

  final resNames = <String>[
    'Mcdonald',
    'Burger King',
    'Lime Kitchen',
    'Midnight',
    'Lion',
    'The Goat',
    'The Greek Star',
    'The Fantasy Food',
    'The Golden Chef',
    'Fire and Ice',
    'Roots',
    'The Spring Block',
    'The Italian Table',
    'The Eastern Hook',
    'The Curry Oak',
    'The Olive Pizzeria',
    'The Minty Merchant',
    'Little Persia'
  ];

  void fill() {
    // order of these calls matters, do not change! (Literally spaghetti)
    generateOwnerAccount(false);
    for (var i = 0; i < 10; i++) {
      generateOwnerAccount(true);
    }
    generateUserAccount();
  }

  String generatePhoneNumber() {
    var str = '09';
    for (var i = 0; i < 9; i++) {
      str += rand.nextInt(10).toString();
    }
    return str;
  }

  FoodMenu generateFoodMenu() {
    var set = <int>{};
    for (var i = 0; i < 14; i++) {
      set.add(rand.nextInt(foods.length));
    }
    var menu = FoodMenu(server);
    for (var i in set) {
      var food = foods[i];
      menu.addFood(food);
    }
    menu.serialize(server.serializer);
    dataBase.menus.add(menu);
    return menu;
  }

  FoodMenu getSampleMenu() {
    var menu = FoodMenu(server);
    [0, 1, 3, 4, 6, 7, 8, 10, 11, 13, 14, 17].forEach((i) => menu.addFood(foods[i]));
    menu.serialize(server.serializer);
    dataBase.menus.add(menu);
    return menu;
  }

  Restaurant generateRestaurant(bool isRandom) {
    FoodMenu menu;
    if (isRandom) {
      menu = generateFoodMenu();
    } else {
      menu = getSampleMenu();
    }
    var restaurant = Restaurant(name: isRandom ? resNames[rand.nextInt(resNames.length)] : 'SBU Food', menuID: menu.id!, score: rand.nextDouble()*5, address: Address());
    restaurant.foodCategories.addAll(menu.categories);
    restaurant.serialize(server.serializer);
    dataBase.restaurants.add(restaurant);
    var c1 = Comment(server: server, restaurantID: restaurant.id!, score: 4, title: 'Good', message: 'it was good');
    var c2 = Comment(server: server, restaurantID: restaurant.id!, score: 1, title: 'Bad', message: 'it was bad');
    c1.serialize(server.serializer);
    c2.serialize(server.serializer);
    dataBase.comments.add(c1);
    dataBase.comments.add(c2);
    restaurant.commentIDs.add(c1.id!);
    restaurant.commentIDs.add(c2.id!);
    return restaurant;
  }

  Order getSampleOrder(CustomerData customer, bool isRequested, bool isDelivered) {
    var restaurant = dataBase.restaurants[rand.nextInt(dataBase.restaurants.length)];
    var menu = server.getObjectByID(restaurant.menuID!) as FoodMenu;
    var items = <FoodData, int>{};
    for (var category in menu.categories) {
      items[menu.getFoods(category)![0].toFoodData()] = rand.nextInt(3) + 1;
    }
    var order = Order(
      server: server,
      items: items,
      restaurant: restaurant,
      customer: customer,
    );
    order.serialize(server.serializer);
    if (isRequested) {
      order.sendRequest();
      if (isDelivered) {
        order.isDelivered = isDelivered;
      }
    }
    return order;
  }

  OwnerAccount generateOwnerAccount(bool isRandom) {
    var acc = OwnerAccount(phoneNumber: isRandom ? generatePhoneNumber() :'09123123123', restaurant: generateRestaurant(isRandom), server: server);
    dataBase.accounts.add(acc);
    dataBase.ownerOf[acc.restaurant.id!] = acc;
    dataBase.loginData[acc.phoneNumber] = 'owner123';
    if (!isRandom) {
      var order = Order(server: server, items: {foods[0].toFoodData() : 2}, restaurant: acc.restaurant, customer: CustomerData('Mojtaba', 'Vahidi', Address()));
      order.serialize(server.serializer);
      order.sendRequest();
      var order2 = Order(server: server, items: {foods[0].toFoodData() : 2 , foods[3].toFoodData() : 1 , foods[6].toFoodData() : 3}, restaurant: acc.restaurant, customer: CustomerData('Ali', 'Alavi', Address()));
      order2.serialize(server.serializer);
      order2.sendRequest();
    }
    return acc;
  }

  UserAccount generateUserAccount() {
    var user = UserAccount(
        phoneNumber: '09321321321',
        server: server,
        firstName: 'Ali',
        lastName: 'Alavi',
        addresses: [Address(name: 'home')],
        defaultAddressName: 'home',
        favRestaurantIDs: [dataBase.restaurants[0].id!, dataBase.restaurants[1].id!, dataBase.restaurants[2].id!],
        commentIDs: [dataBase.comments[0].id!, dataBase.comments[2].id!, dataBase.comments[5].id!,]
    );
    var customerData = user.toCustomerData(user.defaultAddress!);
    user.cart.add(getSampleOrder(customerData, false, false));
    user.cart.add(getSampleOrder(customerData, false, false));
    user.previousOrders.add(getSampleOrder(customerData, true, true));
    user.previousOrders.add(getSampleOrder(customerData, true, true));
    user.activeOrders.add(getSampleOrder(customerData, true, false));
    user.activeOrders.add(getSampleOrder(customerData, true, false));
    dataBase.loginData[user.phoneNumber] = 'user321';
    dataBase.accounts.add(user);
    return user;
  }

}