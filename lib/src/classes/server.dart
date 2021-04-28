import 'fake_data_base.dart';
import 'order.dart';
import 'editable.dart';
import 'serializer.dart';
import 'account.dart';
import 'owner_account.dart';
import 'food_menu.dart';

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

  bool isIDValid(String id) {
    var pattern = RegExp(r'^([RMCOF]-)?([0-9ABCDEF]{4})-([0-9ABCDEF]{4})$');
    return pattern.hasMatch(id);
  }


  void edit(Editable object) {
    //TODO implement edit
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
          // if this account is for owner, fina and assign its restaurant's menu
          if (_account is OwnerAccount) {
            (_account as OwnerAccount).restaurant.menu = getObjectByID((_account as OwnerAccount).restaurant.menuID!) as FoodMenu;
          }
          return true;
        }
      }
    }
    return false;
  }

  Object? getObjectByID(String id) {
    if (!isIDValid(id)) return null;

    if (id.startsWith('M-')) {
      for (var menu in dataBase!.menus) {
        if (menu.id == id) return menu;
      }
    }

    if (id.startsWith('R-')) {
      for (var res in dataBase!.restaurants) {
        if (res.id == id) return res;
      }
    }

    if (id.startsWith('C-')) {
      for (var comment in dataBase!.comments) {
        if (comment.id == id) return comment;
      }
    }

    if (id.startsWith('O-')) {
      for (var order in dataBase!.orders) {
        if (order.id == id) return order;
      }
    }

    // if (id.startsWith('F-')) {
    //   for (var food in dataBase!.foods) {
    //     if (food.id == id) return food;
    //   }
    // }

    return null;
  }

}