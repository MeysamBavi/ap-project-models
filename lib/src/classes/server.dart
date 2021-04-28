import 'fake_data_base.dart';
import 'order.dart';
import 'editable.dart';
import 'serializer.dart';
import 'account.dart';

class Server {

  Server([DataBase? dataBase]) : this.dataBase = dataBase;

  Account? _account;
  DataBase? dataBase;
  String token = '';
  final serializer = Serializer();

  Account? get account => _account;

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

  bool login(String phoneNumber, String password) {
    var correctPassword = dataBase!.loginData[phoneNumber];
    if (correctPassword == null) return false;
    if (password == correctPassword) {
      for (var acc in dataBase!.accounts) {
        if (acc.phoneNumber == phoneNumber) {
          _account = acc;
          return true;
        }
      }
    }
    return false;
  }

}