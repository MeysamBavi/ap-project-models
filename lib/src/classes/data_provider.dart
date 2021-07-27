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

class RestaurantProvider {

  bool _isUsed;
  final _random = Random();
  final _serializer = Serializer();
  final DataBase dataBase;
  final Server server;

  static const int _MAXIMUM_NUMBER_OF_IRANIAN_RESTAURANTS = 5;
  static const int _MAXIMUM_NUMBER_OF_FASTFOOD_RESTAURANTS = 7;
  static const int _MAXIMUM_NUMBER_OF_OTHER_RESTAURANTS = 9;

  //this is based on the total number of restaurant names and number of unique addresses
  static const int MAXIMUM_NUMBER_OF_RESTAURANTS = _MAXIMUM_NUMBER_OF_IRANIAN_RESTAURANTS + _MAXIMUM_NUMBER_OF_FASTFOOD_RESTAURANTS + _MAXIMUM_NUMBER_OF_OTHER_RESTAURANTS;

  RestaurantProvider(this.dataBase, this.server)  : _isUsed = false;

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

  var _commentTemplates = <_CommentTemplate>[
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

  void _generateAndAddComment(_CommentTemplate template, Restaurant restaurant) {
    var comment = Comment(
      server: server,
      score: template.score,
      message: template.message,
      title: template.title,
      restaurantID: restaurant.id!,
    );
    comment.id = _serializer.createID(comment.runtimeType);
    dataBase.comments.add(comment);
    restaurant.commentIDs.add(comment.id!);
  }

  void _generateAndAddRestaurant(Set<FoodCategory> categories) {
    var menu = FoodMenu(server);
    menu.id = _serializer.createID(menu.runtimeType);
    dataBase.menus.add(menu);

    for (var i = 0; i < categories.length; i++) {
      var l = _random.nextInt(3) + 4;
      for (var j = 0; i < l; j++) {
        menu.addFood(_generateFood(categories.elementAt(i)));
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

    var score = _random.nextDouble() * 4.5 + 0.5;
    var numberOfComments = _random.nextInt(8) + pow(1.625, score);

    var restaurant = Restaurant(
      name: name,
      foodCategories: categories,
      address: _getAddress(),
      menuID: menu.id!,
      areaOfDispatch: _random.nextDouble() * 4000 + 2000,
      score: score,
      numberOfComments: numberOfComments.toInt(),
    );

    restaurant.id = _serializer.createID(restaurant.runtimeType);
    dataBase.restaurants.add(restaurant);

    var commentTemplatesCopy = _commentTemplates.sublist(0);
    var l = min(numberOfComments, commentTemplatesCopy.length);

    for (var i = 0; i < l; i++) {
      _generateAndAddComment(commentTemplatesCopy.removeAt(_random.nextInt(commentTemplatesCopy.length)), restaurant);
    }
  }

  void fill() {
    if (_isUsed) throw Exception('This object is already used');
    _isUsed = true;

    for (var i = 0 ; i < _MAXIMUM_NUMBER_OF_IRANIAN_RESTAURANTS; i++) {
      _generateAndAddRestaurant({FoodCategory.Iranian});
    }
    for (var i = 0 ; i < _MAXIMUM_NUMBER_OF_FASTFOOD_RESTAURANTS; i++) {
      _generateAndAddRestaurant({FoodCategory.FastFood});
    }
    for (var i = 0 ; i < _MAXIMUM_NUMBER_OF_OTHER_RESTAURANTS; i++) {
      var categories = FoodCategory.values.sublist(0);
      var l = _random.nextInt(max(1, FoodCategory.values.length - 1));
      for (var j = 0; i < l; j++) {
        categories.removeAt(_random.nextInt(categories.length));
      }
      _generateAndAddRestaurant(categories.toSet());
    }
  }

}

class _CommentTemplate {
  String title;
  String message;
  int score;

  _CommentTemplate(this.title, this.message, this.score);

}