import 'fake_data_base.dart';
import 'server.dart';
import 'dart:math';
import 'food.dart';
import 'price.dart';
import 'restaurant.dart';
import 'food_menu.dart';
import 'serializer.dart';
import 'address.dart';
import 'comment.dart';
import 'small_data.dart';
import 'order.dart';
import 'user_account.dart';
import 'fake_server.dart';
import 'owner_account.dart';
import 'discount.dart';

class RestaurantProvider {

  bool _isUsed;
  final _random = Random();
  final _serializer = Serializer();
  final DataBase dataBase;
  final Server server;
  final bool _isForUser;

  static const int _MAXIMUM_NUMBER_OF_IRANIAN_RESTAURANTS = 5;
  static const int _MAXIMUM_NUMBER_OF_FASTFOOD_RESTAURANTS = 7;
  static const int _MAXIMUM_NUMBER_OF_OTHER_RESTAURANTS = 9;

  //this is based on the total number of restaurant names and number of unique addresses
  static const int MAXIMUM_NUMBER_OF_RESTAURANTS = _MAXIMUM_NUMBER_OF_IRANIAN_RESTAURANTS + _MAXIMUM_NUMBER_OF_FASTFOOD_RESTAURANTS + _MAXIMUM_NUMBER_OF_OTHER_RESTAURANTS;

  RestaurantProvider.forUser(this.dataBase, this.server)  : _isUsed = false, _isForUser = true;

  RestaurantProvider.forOwner(this.dataBase, this.server)  : _isUsed = false, _isForUser = false;

  //should only be called for user
  void fill() {
    if (_isUsed) throw Exception('This object is already used');
    _isUsed = true;

    if (!_isForUser) throw Exception('Illegal method call; \'fill\' is only for user.');

    for (var i = 0 ; i < _MAXIMUM_NUMBER_OF_IRANIAN_RESTAURANTS; i++) {
      _generateAndAddRestaurant({FoodCategory.Iranian});
    }
    print('irani done');
    for (var i = 0 ; i < _MAXIMUM_NUMBER_OF_FASTFOOD_RESTAURANTS; i++) {
      _generateAndAddRestaurant({FoodCategory.FastFood});
    }
    print('fastfood done');
    for (var i = 0 ; i < _MAXIMUM_NUMBER_OF_OTHER_RESTAURANTS; i++) {
      var categories = FoodCategory.values.sublist(0);
      var l = _random.nextInt(max(1, FoodCategory.values.length - 1));
      for (var j = 0; j < l; j++) {
        categories.removeAt(_random.nextInt(categories.length));
      }
      _generateAndAddRestaurant(categories.toSet());
    }
    print('other done');
  }

  var _iranianNames = <String>[
    'Akbar Jooje',
    'Nemoone',
    'Eram',
    'Gilan',
    'Alighapoo',
    'Hosseini',
    'Khan Salar',
  ];

  var _fastFoodNames = <String>[
    'The Greek Star',
    'The Fantasy Food',
    'The Golden Chef',
    'Roots',
    'The Italian Table',
    'The Olive Pizzeria',
    'Little Persia'
  ];

  var _otherNames = <String>[
    'Lime Kitchen',
    'Midnight',
    'Lion',
    'The Goat',
    'Fire and Ice',
    'The Spring Block',
    'The Eastern Hook',
    'The Minty Merchant',
    'The Curry Oak',
  ];

  var _foodNames = <FoodCategory, List<String>>{
    FoodCategory.Iranian : [
      'Kabab',
      'Jooje Kabab',
      'Qeyme',
      'Qorme Sabzi',
      'Mirza Qasemi',
      'Kabab Barg',
      'Fesenjan',
      'Kabab Soltani',
      'Kask Bademjoon',
      'Baqali Polo',
      'Khorak Morq',
      'Sabzi Polo',
      'Kalam Polo',
    ],
    FoodCategory.SeaFood : [
      'Sushi',
      'Shark',
      'Tuna',
      'Shrimp',
    ],
    FoodCategory.FastFood : [
      'Italian Pizza',
      'Burger',
      'Double Burger',
      'Cheese Burger',
      'Greek Pizza',
      'Vegetable Pizza',
      'Fried Chicken',
      'French Fries',
      'American Pizza',
      'Pizza Pepperoni',
      'Taco',
      'Lasagna',
    ]
  };

  var _descriptions = <FoodCategory, List<String>>{
    FoodCategory.Iranian : [
      'An original iranian food',
      'Completely organic',
    ],
    FoodCategory.SeaFood : [
      'Fresh and juicy',
      'All ingredients are natural',
    ],
    FoodCategory.FastFood : [
      'Hot and ready',
      'Very delicious',
    ],
  };

  var _addresses = <Address>[
    Address(text: 'Tehran, Seyed Khandan, Shariati St', latitude: 35.745552, longitude: 51.448457),
    Address(text: 'Tehran, Tajrish, Shariati St', latitude: 35.797937, longitude: 51.433922),
    Address(text: 'Tehran, Jannat Abad', latitude: 35.748261, longitude: 51.303955),
    Address(text: 'Tehran, Azadi St', latitude: 35.699976, longitude: 51.343672),
    Address(text: 'Tehran, Velenjak', latitude: 35.80, longitude: 51.401),
    Address(text: 'Tehran, Hakimieh, Bahar Blvd', latitude: 35.743038, longitude: 51.582791),
    Address(text: 'Tehran, Piroozi St', latitude: 35.692395, longitude: 51.486098),
    Address(text: 'Tehran, Mosalla', latitude: 35.735583, longitude: 51.434393),
    Address(text: 'Tehran, Moniriey', latitude: 35.683417, longitude: 51.402119),
    Address(text: 'Tehran, Aseman, Farahzadi Blvd', latitude: 35.780622, longitude: 51.355036),
    Address(text: 'Tehran, Yaft Abad', latitude: 35.664891, longitude: 51.319685,),
    Address(text: 'Tehran, Shah Abdol-Azim', latitude: 35.590731, longitude: 51.436235),
    Address(text: 'Tehran, Sattar Khat St', latitude: 35.720410, longitude: 51.356183),
    Address(text: 'Tehran, Poonak', latitude: 35.763282, longitude: 51.336570),
    Address(text: 'Tehran, Shahrak Ekbatan', latitude: 35.711049, longitude: 51.315599),
    Address(text: 'Tehran, Chitgar Lake', latitude: 35.746023, longitude: 51.222089),
    Address(text: 'Mashhad, Kooh Sangi', latitude: 36.287114, longitude: 59.569927),
    Address(text: 'Mashhad, Shohada Square', latitude: 36.297591, longitude: 59.604035),
    Address(text: 'Mashhad, Hashemi Nejad', latitude: 36.302489, longitude: 59.618861),
    Address(text: 'Mashhad, Ayatolah Bahjat St', latitude: 36.295543, longitude: 59.612431),
    Address(text: 'Mashhad, Ab Square', latitude: 36.283490, longitude: 59.612113),
  ];



  Address _getAddress() {
    return _addresses.removeAt(_random.nextInt(_addresses.length));
  }

  Food _generateFood(FoodCategory category) {
    var food = Food(
      server: server,
      price: Price((_random.nextInt(61) + 30) * 1000),
      category: category,
      name: _foodNames[category]![_random.nextInt(_foodNames[category]!.length)],
      isAvailable: _random.nextDouble() < 0.75 ? true : false,
      description: _descriptions[category]![_random.nextInt(_descriptions[category]!.length)],
    );
    food.id = _serializer.createID(food.runtimeType);
    return food;
  }

  void _generateAndAddRestaurant(Set<FoodCategory> categories) {
    var menu = FoodMenu(server);
    menu.id = _serializer.createID(menu.runtimeType);
    dataBase.menus.add(menu);

    for (var category in categories) {
      var l = _random.nextInt(3) + 4;
      for (var j = 0; j < l; j++) {
        menu.justAddFood(_generateFood(category));
      }
    }

    String name = 'NO NAME';
    if (categories.length > 1 || categories.contains(FoodCategory.SeaFood)) {
      name = _otherNames.removeAt(_random.nextInt(_otherNames.length));
    } else if (categories.contains(FoodCategory.Iranian)) {
      name = _iranianNames.removeAt(_random.nextInt(_iranianNames.length));
    } else {
      name = _fastFoodNames.removeAt(_random.nextInt(_fastFoodNames.length));
    }

    var score = _getRandomScore();
    var numberOfComments = _random.nextInt(8) + pow(1.625, score);

    var restaurant = Restaurant(
      name: name,
      foodCategories: categories,
      address: _getAddress(),
      menuID: menu.id!,
      areaOfDispatch: _random.nextDouble() * 4000 + 5000,
      score: score,
      numberOfComments: numberOfComments.toInt(),
    );

    restaurant.id = _serializer.createID(restaurant.runtimeType);
    restaurant.menu = menu; // critical line; this makes OrderProvider access the restaurant's menu without having to search database
    dataBase.restaurants.add(restaurant);

    CommentProvider(dataBase, server).generateAndAddUniqueCommentsForRestaurant(restaurant, numberOfComments.toInt());

  }

  double _getRandomScore() {
    return 3.5 * sqrt(_random.nextDouble()) + 1.5;
  }

  Restaurant getRestaurantInstanceForOwner() {
    if (_isForUser) throw Exception('Illegal method call; \'fill\' is only for owner.');

    _generateAndAddRestaurant({FoodCategory.FastFood, FoodCategory.SeaFood});

    return dataBase.restaurants[0];
  }

}

class _CommentTemplate {
  String title;
  String message;
  int score;

  _CommentTemplate(this.title, this.message, this.score);

}

class CommentProvider {

  final DataBase dataBase;
  final Server server;
  final _random = Random();
  final _serializer = Serializer();

  CommentProvider(this.dataBase, this.server);

  final _source = <_CommentTemplate>[
    _CommentTemplate('It was nice', 'It was good. I will probably order again', 4),
    _CommentTemplate('Never order', 'Food came cold and it tasted bad', 1),
    _CommentTemplate('It was good', 'Food came in hot, but delivery was late. It was good overall', 3),
    _CommentTemplate('Great!!', 'I think I found my favorite restaurant :)', 5),
    _CommentTemplate('Bad Packaging', 'Packaging was bad and food was spilled all over. I got a refund however', 2),
    _CommentTemplate('Seen Better', 'Not really tasty and delicious', 4),
    _CommentTemplate('It used to be better', 'Your food used to be better, i don\' know what happened', 2),
    _CommentTemplate('Very Good', 'just came in hot and quick', 5),
    _CommentTemplate('so little', 'I expected a lot more for what i paid. it tasted good tho', 3),
    _CommentTemplate('Old customer', 'Ordering from here for 3 years! Always the best', 4),
    _CommentTemplate('Came late and cold', 'never ordering again', 0),
    _CommentTemplate('Good', 'nice and tidy as always', 4),
    _CommentTemplate('a bit cold', 'it was good overall, just a bit cold', 4),
    _CommentTemplate('Great', 'great.', 5),
    _CommentTemplate('Wrong order', 'this was\'t my order, what the hell', 1),
    _CommentTemplate('Nice', 'evidently using fresh ingredients, well done', 4),
    _CommentTemplate('Really good', 'Tasted like... a great food!', 5),
    _CommentTemplate('nice', 'as always good', 4),
  ];

  var _temp = [];

  Comment generateAndAddComment(Restaurant restaurant, [_CommentTemplate? template]) {

    if (template == null) {
      if (_temp.isEmpty) {
        _temp = _source.sublist(0);
      }
      template = _temp.removeAt(_random.nextInt(_temp.length));
    }

    var comment = Comment(
      server: server,
      score: template!.score,
      message: template.message,
      title: template.title,
      restaurantID: restaurant.id!,
    );
    comment.id = _serializer.createID(comment.runtimeType);
    dataBase.comments.add(comment);
    restaurant.commentIDs.add(comment.id!);
    return comment;
  }

  void generateAndAddUniqueCommentsForRestaurant(Restaurant restaurant, int numberOfComments) {
    var temp2 = _source.sublist(0);
    var l = min(numberOfComments, temp2.length);

    for (var i = 0; i < l; i++) {
      generateAndAddComment(restaurant, temp2.removeAt(_random.nextInt(temp2.length)));
    }
  }
}

// receives a database filled with restaurants and menus, and creates orders
class OrderProvider {

  final UserAccount? user;
  final OwnerAccount? owner;
  final DataBase dataBase;
  final Server server;
  final bool _isForUser;
  final _random = Random();
  final _serializer = Serializer();
  var _streamsAreRunning = false;
  var _remainingOrders = 100;
  var _remainingComments = 100;

  OrderProvider.forUser({required this.user, required this.dataBase, required this.server}) : _isForUser = true, owner = null;

  OrderProvider.forOwner({required this.owner, required this.dataBase, required this.server})  : user = null, _isForUser = false;

  var _customers = [
    CustomerData('Meysam', 'Bavi', Address(latitude: 34.640740, longitude: 50.874652, text: 'Qom, somewhere fun')),
    CustomerData('Sina', 'Taheri Behrooz', Address(latitude: 35.700908, longitude: 51.377503, text: 'Tehran, somewhere fun')),
    CustomerData('Mojtaba', 'Vahidi', Address(latitude: 35.795538, longitude: 51.397714, text: 'Tehran, somewhere fun')),
  ];

  void fill() {
    if (_isForUser) {
      _userFill();
    } else {
      _ownerFill();
    }
  }

  void _userFill() {
    for (var i = 0; i < 3; i++) {
      user!.activeOrders.add(_generateAndAddOrder(customer: user!.toCustomerData(user!.defaultAddress!), isRequested: true));
      (server as FakeUserServer).setDeliveryTimeFor(user!.activeOrders[i], Duration(seconds: 15 + i*10));
      user!.previousOrders.add(_generateAndAddOrder(customer: user!.toCustomerData(user!.defaultAddress!), isRequested: true, isDelivered: true));
      user!.cart.add(_generateAndAddOrder(customer: user!.toCustomerData(user!.defaultAddress!), isRequested: true, isDelivered: true, serialize: false));
    }

    var comment = CommentProvider(dataBase, server).generateAndAddComment(user!.previousOrders[0].restaurant);
    user!.commentIDs.add(comment.id!);
  }

  Order _generateAndAddOrder({CustomerData? customer, bool isDelivered = false, bool isRequested = false, DateTime? time, Restaurant? restaurant, bool serialize = true}) {
    if (customer == null) {
      customer = _customers[_random.nextInt(_customers.length)];
    }

    if (restaurant == null) {
      restaurant = dataBase.restaurants[_random.nextInt(dataBase.restaurants.length)];
    }

    var items = <FoodData, int>{};

    for (var category in restaurant.menu!.categories) {
      items[restaurant.menu!.getFoods(category)![0].toFoodData()] = _random.nextInt(3) + 1;
    }

    var order = Order(
      items: items,
      restaurant: restaurant,
      customer: customer,
      server: server,
      isDelivered: isDelivered,
      isRequested: isRequested,
      time: time,
    );

    if (serialize) {
      order.id = _serializer.createID(order.runtimeType);
      order.code = order.id!;
    }
    dataBase.orders.add(order);

    return order;
  }

  void _ownerFill() {
    if (owner!.restaurant.menu!.isNotEmpty) {
      owner!.previousOrders.addAll(
          [
            _generateAndAddOrder(isRequested: true, isDelivered: true, time: DateTime.parse('2021-01-10 12:37:00'), restaurant: owner!.restaurant),
            _generateAndAddOrder(isRequested: true, isDelivered: true, time: DateTime.parse('2021-01-12 13:11:00'), restaurant: owner!.restaurant),
            _generateAndAddOrder(isRequested: true, isDelivered: true, time: DateTime.parse('2021-02-22 15:33:00'), restaurant: owner!.restaurant),
            _generateAndAddOrder(isRequested: true, isDelivered: true, time: DateTime.parse('2021-02-27 14:58:00'), restaurant: owner!.restaurant),
            _generateAndAddOrder(isRequested: true, isDelivered: true, time: DateTime.parse('2021-03-10 16:01:00'), restaurant: owner!.restaurant),
            _generateAndAddOrder(isRequested: true, isDelivered: true, time: DateTime.parse('2021-03-25 16:01:00'), restaurant: owner!.restaurant),
            _generateAndAddOrder(isRequested: true, isDelivered: true, time: DateTime.parse('2021-04-02 16:01:00'), restaurant: owner!.restaurant),
            _generateAndAddOrder(isRequested: true, isDelivered: true, time: DateTime.now(), restaurant: owner!.restaurant),
          ]);
    }
  }

  Stream<Order> _getOrderStream() async* {
    while (_streamsAreRunning && _remainingOrders > 0) {
      await Future.delayed(Duration(seconds: _random.nextInt(11) + 50));
      print('menu is empty: ' + owner!.restaurant.menu!.isEmpty.toString());
      if (owner!.restaurant.menu!.isNotEmpty) {
        _remainingOrders--;
        yield _generateAndAddOrder(restaurant: owner!.restaurant);
      }
    }
  }

  Stream<Comment> _getCommentStream() async* {
    var commentProvider = CommentProvider(dataBase, server);
    while (_streamsAreRunning && _remainingComments > 0) {
      await Future.delayed(Duration(seconds: _random.nextInt(31) + 70));
      if (owner!.restaurant.menu!.isNotEmpty) {
        _remainingComments--;
        yield commentProvider.generateAndAddComment(owner!.restaurant);
      }
    }
  }

  void openStreams() {
    if (_streamsAreRunning) return;

    _getOrderStream().listen((order) {
      owner!.activeOrders.add(order);
      print('order added');
    });
    _getCommentStream().listen((comment) {
      print('comment added');
    });
    _streamsAreRunning = true;
  }

  void closeStreams() {
    _streamsAreRunning = false;
  }
}


class UserProvider {


  static const userPhoneNumber = '09123456789';
  static const userPassword = 'password1';

  static UserAccount getUserInstance(DataBase dataBase, Server server) {
    var user = UserAccount(
      firstName: 'Ali',
      lastName: 'Alavi',
      phoneNumber: userPhoneNumber,
      addresses: [
        Address(latitude: 35.710639,
            longitude: 51.392359,
            name: 'home',
            text: 'Tehran, Laleh Park')
      ],
      defaultAddressName: 'home',
      commentIDs: [],
      favRestaurantIDs: [],
      server: server,
    );
    dataBase.usersLoginData[userPhoneNumber] = userPassword;
    dataBase.userAccounts.add(user);
    return user;
  }

}

class OwnerProvider {

  static const ownerPhoneNumber = '09123123123';
  static const ownerPassword = 'password1';

  static OwnerAccount getOwnerInstance(DataBase dataBase, Server server) {
    var owner = OwnerAccount(
      phoneNumber: ownerPhoneNumber,
      server: server,
      restaurant: RestaurantProvider.forOwner(dataBase, server).getRestaurantInstanceForOwner(),
    );
    dataBase.ownersLoginData[ownerPhoneNumber] = ownerPassword;
    dataBase.ownerAccounts.add(owner);
    return owner;
  }
}

class DiscountProvider {
  final DataBase dataBase;

  DiscountProvider(this.dataBase);

  void fill() {
    for (var i = 1; i <= 10; i++) {
      dataBase.discounts.add(Discount('off-${i*10}', i*10));
    }
  }
}