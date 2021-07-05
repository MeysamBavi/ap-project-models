import 'dart:convert';
import 'custom_socket.dart';
import 'editable.dart';
import 'food_menu.dart';
import 'order.dart';
import 'restaurant.dart';
import 'comment.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;
import 'address.dart';

abstract class Server {
  final String separator = '|*|*|';
  late CustomSocket _socket;
  String? _ip;
  int? _port;

  String? get ip => _ip;
  int? get port => _port;

  void setSocket(String ip, int port) {
    _ip = ip;
    _port = port;
    _socket = CustomSocket(_ip!, _port!);
  }

  String createMessage(List<String> commands);

  Future<String> sendAndReceive(List<String> commands) async {
    return await _socket.writeString(createMessage(commands));
  }

  static bool isPhoneNumberValid(String phoneNumber) {
    var pattern = RegExp(r'^09\d{9}$');
    return pattern.hasMatch(phoneNumber);
  }

  static bool isPasswordValid(String password) {
    var pattern = RegExp(r'^(?=.{6,}$)(?=.*[0-9])(?=.*[a-zA-Z])[0-9a-zA-Z]+$');
    return pattern.hasMatch(password);
  }

  static int onScore(Restaurant a, Restaurant b) => (b.score - a.score).sign.toInt();
  static int Function(Restaurant, Restaurant) createOnDistance(double latitude, double longitude) {
    return (Restaurant a, Restaurant b) {
      var distanceToA = Geolocator.distanceBetween(a.address.latitude, a.address.longitude, latitude, longitude);
      var distanceToB = Geolocator.distanceBetween(b.address.latitude, b.address.longitude, latitude, longitude);
      return (distanceToA - distanceToB).sign.toInt();
    };
  }

  Future<void> edit(Editable object);

  Future<bool> login(String phoneNumber, String password);

  Future<bool> isPhoneNumberUnique(String phoneNumber) async {
    var message = await sendAndReceive(['isPhoneNumberUnique', phoneNumber]);
    return message == 'true' ? true : false;
  }

  Future<String> serialize(Type type) async {
    return await sendAndReceive(['serialize', type.toString().toLowerCase()]);
  }

  Future<T?> getObjectByID<T>(String id) async {

    if (T == dynamic) {
      throw Exception('Object type can\'t be dynamic.');
    }

    if (T == FoodMenu) {
      String message = await sendAndReceive(['getMenu', id]);
      return FoodMenu.fromJson(jsonDecode(message), this) as T;
    }
    String message = await sendAndReceive(['get', id]);
    switch (T) {
      case Order:
        return Order.fromJson(jsonDecode(message), this) as T;
      case Restaurant:
        return Restaurant.fromJson(jsonDecode(message)) as T;
      case Comment:
        return Comment.fromJson(jsonDecode(message), this) as T;
    }
    return null;
  }

  bool isInArea(Address customer, Address restaurant, double radius) {
    if (radius == 0.0) return true;
    return Geolocator.distanceBetween(restaurant.latitude, restaurant.longitude, customer.latitude, customer.longitude) <= radius;
  }

}