import '../../models.dart';
import 'dart:math';

class DataBase {
  final List<Account> accounts;
  final List<Restaurant> restaurants;
  final List<Comment> comments;
  final List<FoodMenu> menus;
  final List<Order> orders;
  final Map<String, String> loginData;

  DataBase({
  required this.accounts,
  required this.restaurants,
  required this.comments,
  required this.menus,
  required this.orders,
  required this.loginData
});

  static DataBase empty() {
    return DataBase(accounts: [], restaurants: [], comments: [], menus: [], orders: [], loginData: {});
  }

}

class FakeData {

  final DataBase dataBase;
  final Server server;
  final rand = Random(DateTime.now().second);

  final List<Food> foods;

  FakeData(this.dataBase, this.server)  :
        foods = <Food>[
    Food(name: 'Pepperoni', category: FoodCategory.FastFood, price: Price(35000), server: server),
    Food(name: 'Sushi', category: FoodCategory.SeaFood, price: Price(50000), server: server),
    Food(name: 'Fish', category: FoodCategory.SeaFood, price: Price(30000), server: server),
    Food(name: 'Kabab', category: FoodCategory.Iranian, price: Price(20000), server: server),
    Food(name: 'Fired Chicken', category: FoodCategory.FastFood, price: Price(45000), server: server),
    Food(name: 'Lasagna', category: FoodCategory.FastFood, price: Price(23000), server: server),
    Food(name: 'Pasta', category: FoodCategory.FastFood, price: Price(27000), server: server),
    Food(name: 'Qeyme', category: FoodCategory.Iranian, price: Price(20000), server: server),
    Food(name: 'Sardine', category: FoodCategory.SeaFood, price: Price(12000), server: server),
    Food(name: 'Eggs', category: FoodCategory.Iranian, price: Price(5000), server: server),
    Food(name: 'Burger', category: FoodCategory.FastFood, price: Price(32000), server: server),
    Food(name: 'Taco', category: FoodCategory.FastFood, price: Price(94000), server: server),
    Food(name: 'Salsa', category: FoodCategory.FastFood, price: Price(43000), server: server),
    Food(name: 'Jooje', category: FoodCategory.Iranian, price: Price(17000), server: server),
    Food(name: 'Tuna', category: FoodCategory.SeaFood, price: Price(28000), server: server),
    Food(name: 'Shark', category: FoodCategory.SeaFood, price: Price(88000), server: server),
  ];

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
    generateOwnerAccount();
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
    for (var i = 0; i < 7; i++) {
      set.add(rand.nextInt(foods.length));
    }
    var menu = FoodMenu(server);
    menu.serialize(server.serializer);
    for (var i in set) {
      var food = foods[i];
      food.serialize(server.serializer);
      menu.addFood(food);
    }
    dataBase.menus.add(menu);
    return menu;
  }

  Restaurant generateRestaurant() {
    var menu = generateFoodMenu();
    var restaurant = Restaurant(name: resNames[rand.nextInt(resNames.length)], menuID: menu.id, score: rand.nextDouble()*5);
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

  OwnerAccount generateOwnerAccount() {
    var acc = OwnerAccount(phoneNumber: '09123123123', restaurant: generateRestaurant(), server: server);
    dataBase.accounts.add(acc);
    dataBase.loginData[acc.phoneNumber] = 'owner123';
    acc.activeOrders.add(Order(server: server, items: {FoodData('pizza', Price(26000)) : 2}, restaurant: acc.restaurant, customer: CustomerData('Mojtaba', 'Vahidi', Address())));
    return acc;
  }

  UserAccount generateUserAccount() {
    var user = UserAccount(
        phoneNumber: '09321321321',
        server: server,
        firstName: 'Ali',
        lastName: 'Alavi',
        addresses: {'home' : Address()},
        favRestaurantIDs: [dataBase.restaurants[0].id!],
        commentIDs: [dataBase.comments[0].id!]
    );
    dataBase.loginData[user.phoneNumber] = 'user321';
    dataBase.accounts.add(user);
    return user;
  }

}