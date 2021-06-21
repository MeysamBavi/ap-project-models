import 'editable.dart';
import 'order.dart';
import 'server.dart';

abstract class Account implements Editable {
  final String phoneNumber;
  final List<Order> previousOrders;
  final List<Order> activeOrders;
  Server _server;

  Account({
    required this.phoneNumber,
    required Server server,
    List<Order>? previousOrders,
    List<Order>? activeOrders,
  }) :  this.previousOrders = previousOrders ?? <Order>[],
        this.activeOrders = activeOrders ?? <Order>[],
        _server = server;

  @override
  Server get server => _server;
}
