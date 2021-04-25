import 'serializer.dart';

class Server {

  final serializer = Serializer();

  bool isPhoneNumberValid(String phoneNumber) {
    var pattern = RegExp(r'^09\d{9}$');
    return pattern.hasMatch(phoneNumber);
  }
  
  bool isPasswordValid(String password) {
    var pattern = RegExp(r'^(?=.{6,}$)(?=.*[0-9])(?=.*[a-zA-Z])[0-9a-zA-Z]+$');
    return pattern.hasMatch(password);
  }

}