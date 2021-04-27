import 'fake_data_base.dart';

import 'order.dart';
import 'editable.dart';
import 'serializer.dart';

class Server {

  Server([DataBase? dataBase]) : this.dataBase = dataBase;

  DataBase? dataBase;

  final serializer = Serializer();

  String token = '';

  bool isPhoneNumberValid(String phoneNumber) {
    var pattern = RegExp(r'^09\d{9}$');
    return pattern.hasMatch(phoneNumber);
  }
  
  bool isPasswordValid(String password) {
    var pattern = RegExp(r'^(?=.{6,}$)(?=.*[0-9])(?=.*[a-zA-Z])[0-9a-zA-Z]+$');
    return pattern.hasMatch(password);
  }

  void edit(Editable object) {
    //TODO implement edit
  }

  bool isPasswordCorrect(String phoneNumber) {
    //TODO implement password check
    return false;
  }

  void addNewOrder(Order order) {
    //TODO implement new order handling
  }

}