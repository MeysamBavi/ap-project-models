import 'address.dart';
import 'price.dart';

class CustomerData {

  final String firstName;
  final String lastName;
  final Address address;

  CustomerData(this.firstName, this.lastName, this.address);

}

class FoodData {
  final String name;
  final Price price;
  FoodData(this.name, this.price);
}