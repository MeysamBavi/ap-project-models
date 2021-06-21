import 'account.dart';
import 'server.dart';
import 'restaurant.dart';
import 'order.dart';

class OwnerAccount extends Account {
  final Restaurant restaurant;

  OwnerAccount({
    required String phoneNumber,
    required this.restaurant,
    required Server server,
    List<Order>? previousOrders,
    List<Order>? activeOrders,
}) : super(phoneNumber: phoneNumber, server: server, previousOrders: previousOrders, activeOrders: activeOrders);

  factory OwnerAccount.fromJson(Map<String, dynamic> json, Server server) {
    var restaurant = Restaurant.fromJson(json['restaurant']);
    return OwnerAccount(
      restaurant: restaurant,
      phoneNumber: json['phoneNumber'],
      server: server,
      previousOrders: json['previousOrders'].map<Order>((e) => Order.fromJson(e, server, restaurant)).toList(),
      activeOrders: json['activeOrders'].map<Order>((e) => Order.fromJson(e, server, restaurant)).toList(),
    );
  }

  List<int> calculateCountPrice(DateTime? time, bool previousOrders) {
    var orders = previousOrders ? super.previousOrders : super.activeOrders;
    int count = 0, price = 0;
    orders.forEach((element) {
      if (time == null || _areSameDay(element.time, time)) {
        element.items.forEach((key, value) => count += value);
        price += element.totalCost.toInt();
      }
    });
    return [count, price];
  }

  bool _areSameDay(DateTime a, DateTime b) {
    return (a.day == b.day) && (a.month == b.month) && (a.year == b.year);
  }

}