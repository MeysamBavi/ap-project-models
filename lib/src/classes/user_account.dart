import 'account.dart';
import 'address.dart';
import 'server.dart';
import 'price.dart';
import 'small_data.dart';
import 'order.dart';

class UserAccount extends Account {

  final String firstName;
  final String lastName;
  Price _credit;
  String _defaultAddress;
  final Map<String, Address> addresses;
  final List<String> favRestaurantIDs;
  final List<String> commentIDs;
  // adding and removing from cart should be done manually
  final List<Order> cart;

  UserAccount({
    required String phoneNumber,
    required Server server,
    required this.firstName,
    required this.lastName,
    Price? credit,
    String? defaultAddress,
    required this.addresses,
    required this.favRestaurantIDs,
    required this.commentIDs,
    List<Order>? cart,
})  : _credit = credit ?? Price(0),
      _defaultAddress = defaultAddress ?? '',
      this.cart = cart ?? [],
      super(phoneNumber: phoneNumber, server: server);

  String get defaultAddress => _defaultAddress;

  set defaultAddress(String value) {
    _defaultAddress = value;
    server.edit(this);
  }

  Price get credit => _credit;

  set credit(Price value) {
    _credit = value;
    server.edit(this);
  }

  // can be used for modifying an address too
  void addAddress(String name, Address address) {
    addresses[name] = address;
    server.edit(this);
  }

  void removeAddress(String name) {
    addresses.remove(name);
    server.edit(this);
  }

  void addRestaurant(String ID) {
    favRestaurantIDs.add(ID);
    server.edit(this);
  }

  void removeRestaurant(String ID) {
    favRestaurantIDs.remove(ID);
    server.edit(this);
  }

  void addComment(String ID) {
    commentIDs.add(ID);
    server.edit(this);
  }

  CustomerData toCustomerData(Address address) => CustomerData(firstName, lastName, address);

}