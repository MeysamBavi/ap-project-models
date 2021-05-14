import 'dart:math';
import 'serializable.dart';
import 'restaurant.dart';
import 'food_menu.dart';
import 'food.dart';
import 'comment.dart';
import 'order.dart';

class Serializer {

  static final idPrefix = <Type, String>{
    Restaurant : 'R-',
    FoodMenu : 'M-',
    Comment : 'C-',
    Order : 'O-',
    Food : 'F-'
  };
  
  String createID(Serializable object) {
    var rand = Random();
    String id = idPrefix[object.runtimeType] ?? '';
    id += object.hashCode.toRadixString(16).padLeft(4, '0').substring(0, 4) + '-';
    id += rand.nextInt(0x0ffff + 1).toRadixString(16).padLeft(4, '0');
    id = id.toUpperCase();
    assert (isIDValid(id));
    return id;
  }

  bool isIDValid(String id) {
    var pattern = RegExp(r'^([RMCOF]-)?([0-9ABCDEF]{4})-([0-9ABCDEF]{4})$');
    return pattern.hasMatch(id);
  }

  Serializer._() : super();

  static final _serializer = Serializer._();

  factory Serializer() {
    return _serializer;
  }

}