import 'food.dart';
import 'food_menu.dart';
import 'serializable.dart';
import 'address.dart';

class Restaurant with Serializable {
  final String name;
  FoodMenu? menu;
  final String menuID;
  final Set<FoodCategory> foodCategories;
  Address address;
  double areaOfDispatch; // in meters
  final double score;
  final int numberOfComments;
  final List<String> commentIDs;

  Restaurant({
    required this.name,
    required this.foodCategories,
    required this.menuID,
    required this.score,
    required this.address,
    required this.numberOfComments,
    this.areaOfDispatch = 0,
  })  : commentIDs = [];

  Restaurant.fromJson(Map<String, dynamic> json):
        name = json['name'],
        menuID = json['menuID'],
        foodCategories = <FoodCategory>{ ...json['foodCategories'].map<FoodCategory>((e) => Food.toCategory(e)) },
        address = Address.fromJson(json['address']),
        areaOfDispatch = json['areaOfDispatch'],
        score = json['score'],
        commentIDs = [...json['commentIDs']],
        numberOfComments = json['numberOfComments'].toInt()
  {
    id = json['ID'];
  }

  Map<String, dynamic> toJson() => {
    'ID' : id,
    'name' : name,
    'menuID' : menuID,
    'foodCategories' : foodCategories.map((e) => e.toString()).toList(growable: false),
    'address' : address,
    'areaOfDispatch' : areaOfDispatch,
    'score' : score,
    'commentIDs' : commentIDs,
  };

}