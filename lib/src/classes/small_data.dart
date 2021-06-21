import 'address.dart';
import 'price.dart';

class CustomerData {

  final String firstName;
  final String lastName;
  final Address address;

  CustomerData(this.firstName, this.lastName, this.address);

  CustomerData.fromJson(Map<String, dynamic> json):
  firstName = json['firstName'],
  lastName = json['lastName'],
  address = Address.fromJson(json['address']);

  Map<String, dynamic> toJson() => {
    'firstName' : firstName,
    'lastName' : lastName,
    'address' : address
  };

}

class FoodData {
  final String foodID;
  final String name;
  final Price price;
  FoodData(this.name, this.foodID, this.price);
}