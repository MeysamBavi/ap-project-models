import 'editable.dart';
import 'serializable.dart';
import 'price.dart';
import 'server.dart';
import 'small_data.dart';

class Food with Serializable implements Editable {

  String _name;
  Price _price;
  String _description;
  bool _isAvailable;
  FoodCategory _category;
  Server _server;
  //TODO add Image field

  Food({
    required String name,
    required FoodCategory category,
    required Price price,
    String? description,
    bool isAvailable = true,
    required Server server
  }) :
        _name = name,
        _category = category,
        _price = price,
        _description = description ?? '',
        _isAvailable = isAvailable,
        _server = server;

  String get name => _name;

  Price get price => _price;

  String get description => _description;

  bool get isAvailable => _isAvailable;

  FoodCategory get category => _category;

  @override
  Server get server => _server;

  FoodData toFoodData() => FoodData(_name, _price);

  set category(FoodCategory value) {
    _category = value;
    server.edit(this);
  }

  set isAvailable(bool value) {
    _isAvailable = value;
    server.edit(this);
  }

  set description(String value) {
    _description = value;
    server.edit(this);
  }

  set price(Price value) {
    _price = value;
    server.edit(this);
  }

  set name(String value) {
    _name = value;
    server.edit(this);
  }
}

enum FoodCategory {
  Iranian,
  FastFood,
  SeaFood
}