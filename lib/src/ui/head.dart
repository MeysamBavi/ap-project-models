import 'package:flutter/material.dart';
import '../../src/classes/server.dart';
import '../../src/classes/user_server.dart';
import '../../src/classes/owner_server.dart';
import '../../src/classes/fake_server.dart';
import '../../src/classes/fake_data_base.dart';
import '../../src/classes/data_provider.dart';

class Head extends InheritedWidget {

  final _ServerPointer _serverPointer;
  final bool isForUser;

  Server get server => _serverPointer.value;

  UserServer get userServer {
    var server = _serverPointer.value;
    if (server is! UserServer) throw Exception('Illegal use of getter for UserServer.');
    return server;
  }

  OwnerServer get ownerServer {
    var server = _serverPointer.value;
    if (server is! OwnerServer) throw Exception('Illegal use of getter for OwnerServer.');
    return server;
  }

  Head({
    Key? key,
    required Widget child,
    required Server server,
  })  : _serverPointer = _ServerPointer(server),
        isForUser = server is UserServer,
        super(key: key, child: child);

  static Head of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Head>()!;
  }

  set offlineMode(bool value) {
    if (value) {
      _offlineModeOn();
    } else {
      _offlineModeOff();
    }
  }

  bool get isOnline => server is! FakeServer;

  @override
  bool updateShouldNotify(Head oldWidget) {
    return false;
  }

  void _offlineModeOn() {
    if (isForUser) {
      var dataBase = DataBase.empty();
      print('database created');
      _serverPointer.value = FakeUserServer(dataBase: dataBase);
      print('fake server created');
      RestaurantProvider(dataBase, server).fill();
      print('database filled with restaurant');
      OrderProvider.forUser(dataBase: dataBase, server: server, user: UserProvider.getUserInstance(dataBase, server)).fill();
      print('all done');
    }
  }

  void _offlineModeOff() {
    if (isForUser) {
      _serverPointer.value = UserServer();
    } else {
      _serverPointer.value = OwnerServer();
    }
  }

}

class _ServerPointer {
  Server value;
  _ServerPointer(this.value);
}