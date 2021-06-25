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
  String? _defaultAddressName;
  final List<Address> addresses;
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
    String? defaultAddressName,
    required this.addresses,
    required this.favRestaurantIDs,
    required this.commentIDs,
    List<Order>? cart,
})  : _credit = credit ?? Price(0),
      _defaultAddressName = defaultAddressName,
      this.cart = cart ?? [],
      super(phoneNumber: phoneNumber, server: server);

  UserAccount.fromJson(Map<String, dynamic> json, Server server):
        firstName = json['firstName'],
        lastName = json['lastName'],
        _credit = Price(int.parse(json['credit'])),
        _defaultAddressName = json['defaultAddressName'],
        addresses = json['addresses'].map<Address>((e) => Address.fromJson(e)).toList(),
        favRestaurantIDs = [...json['favRestaurantIDs']],
        commentIDs = [...json['commentIDs']],
        cart = json['cart'].map<Order>((e) => Order.fromJson(e, server)).toList(),
        super(
        phoneNumber: json['phoneNumber'],
        server: server,
        previousOrders: json['previousOrders'].map<Order>((e) => Order.fromJson(e, server)).toList(),
        activeOrders: json['activeOrders'].map<Order>((e) => Order.fromJson(e, server)).toList(),
      );

  Map<String, dynamic> toJson() => {
    'firstName' : firstName,
    'lastName' : lastName,
    'phoneNumber' : phoneNumber,
    'credit' : _credit.toInt().toString(),
    'defaultAddressName' : _defaultAddressName,
    'addresses' : addresses,
    'favRestaurantIDs' : favRestaurantIDs,
    'commentIDs' : commentIDs,
    'cart' : cart,
    'previousOrders' : previousOrders.map((e) => e.id).toList(growable: false),
    'activeOrders' : activeOrders.map((e) => e.id).toList(growable: false)
  };

  Address? get defaultAddress {
    for (var address in addresses) {
      if (address.name == _defaultAddressName) return address;
    }
    return null;
  }

  set defaultAddressName(String? value) {
    _defaultAddressName = value;
    server.edit(this);
  }


  String? get defaultAddressName => _defaultAddressName;

  Price get credit => _credit;

  set credit(Price value) {
    _credit = value;
    server.edit(this);
  }

  void addAddress(Address address) {
    addresses.add(address);
    server.edit(this);
  }

  void removeAddress(Address address) {
    addresses.remove(address);
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