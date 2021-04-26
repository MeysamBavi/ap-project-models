import 'account.dart';
import 'address.dart';
import 'server.dart';
import 'restaurant.dart';

class OwnerAccount extends Account {
  final Restaurant restaurant;

  OwnerAccount({
    required String phoneNumber,
    required this.restaurant,
    required Server server
}) : super(phoneNumber: phoneNumber, server: server);

}