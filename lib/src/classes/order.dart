import 'package:models/models.dart';
import 'package:models/src/classes/editable.dart';

import 'serializable.dart';
import 'price.dart';
import 'small_data.dart';

class Order with Serializable implements Editable {
  final Server server;
  final Map<FoodData, int> items;
  final DateTime time;
  String code;
  bool _isRequested;
  bool _isDelivered;

  final Restaurant restaurant;
  final CustomerData customer;
  Order({
    required this.server,
    required this.items,
    required this.restaurant,
    required this.customer,
    this.code = '',
})  : time = DateTime.now(),
      _isDelivered = false,
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

  void sendRequest() {
    _isRequested = true;
    server.addNewOrder(this);
  }

}
