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

  //a map for storing reused widgets in runtime; like images
  final depot = <Object, Widget>{};

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
    if (_serverPointer.fakeServer != null) {
      _serverPointer.value = _serverPointer.fakeServer!;
      return;
    }
    var dataBase = DataBase.empty();
    if (isForUser) {
      _serverPointer.fakeServer = FakeUserServer(dataBase: dataBase);
      _serverPointer.value = _serverPointer.fakeServer!;
      RestaurantProvider.forUser(dataBase, server).fill();
      OrderProvider.forUser(dataBase: dataBase, server: server, user: UserProvider.getUserInstance(dataBase, server)).fill();
      DiscountProvider(dataBase).fill();
    } else {
      _serverPointer.fakeServer = FakeOwnerServer(dataBase: dataBase);
      _serverPointer.value = _serverPointer.fakeServer!;
      OrderProvider.forOwner(owner: OwnerProvider.getOwnerInstance(dataBase, server), dataBase: dataBase, server: server).fill();
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
  FakeServer? fakeServer; // a variable to save already created fake server for later use
  _ServerPointer(this.value);
}