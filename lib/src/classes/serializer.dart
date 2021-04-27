import '../../models.dart';
import 'dart:math';

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
    String str = idPrefix[object.runtimeType] ?? '';
    str += object.hashCode.toRadixString(16).padLeft(4, '0').substring(0, 4) + '-';
    str += rand.nextInt(0x0ffff + 1).toRadixString(16);
    return str.toUpperCase();
  }

  Serializer._() : super();

  static final _serializer = Serializer._();

  factory Serializer() {
    return _serializer;
  }

}