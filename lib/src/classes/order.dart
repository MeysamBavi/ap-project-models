import 'editable.dart';
import 'serializable.dart';
import 'price.dart';
import 'small_data.dart';
import 'server.dart';
import 'restaurant.dart';

class Order with Serializable implements Editable {
  final Server server;
  final Map<FoodData, int> items;
  DateTime time;
  String? _code;
  bool _isRequested;
  bool _isDelivered;

  final Restaurant restaurant;
  CustomerData customer;
  Order({
    required this.server,
    required this.items,
    required this.restaurant,
    required this.customer,
    String? code,
})  : time = DateTime.now(),
      _isDelivered = false,
      _code = code,
      _isRequested = false;

  bool get isDelivered => _isDelivered;

  set isDelivered(bool value) {
    _isDelivered = value;
    server.edit(this);
  }

  Price get totalCost {
    int result = 0;
    for (var food in items.keys) {
      result += food.price.toInt() * (items[food] ?? 0);
    }
    return Price(result);
  }

  bool get isRequested => _isRequested;

  String get code => _code ?? id ?? 'null';

  set code(String value) {
    _code = value;
  }

  void sendRequest() {
    _isRequested = true;
    time = DateTime.now();
    server.addNewOrder(this);
  }

  Future<Order?> reorder() async {
    return await server.reorder(this);
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    var itemsConverted = <Map<String, dynamic>>[];
    items.forEach((foodData, count) {
      itemsConverted.add({
        'name' : foodData.name,
        'foodID' : foodData.foodID,
        'price' : foodData.price.toInt().toString(),
        'count' : count,
      });
    });
    return {
      'ID' : id,
      'items' : itemsConverted,
      'time' : time.millisecondsSinceEpoch.toString(),
      'code' : _code,
      'isRequested' : _isRequested,
      'isDelivered' : _isDelivered,
      'restaurantID' : restaurant.id,
      'customer' : customer
    };
  }

  Order.fromJson(Map<String, dynamic> json, Server server, [Restaurant? restaurant]):
        items = <FoodData, int>{},
        time = DateTime.fromMillisecondsSinceEpoch(int.parse(json['time'])),
        _code = json['code'],
        _isRequested = json['isRequested'],
        _isDelivered = json['isDelivered'],
        restaurant = restaurant ?? Restaurant.fromJson(json['restaurant']),
        customer = CustomerData.fromJson(json['customer']),
        server = server
  {
    json['items'].forEach((item) {
      items[FoodData(item['name'], item['foodID'], Price(int.parse(item['price'])))] = item['count'].toInt();
    });
    id = json['ID'];
  }
}
