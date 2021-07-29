import 'package:flutter/material.dart';
import '../../src/classes/server.dart';
import '../../src/classes/user_server.dart';
import '../../src/classes/owner_server.dart';

class Head extends InheritedWidget {

  final _ServerPointer _serverPointer;
  final bool _isForUser;

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
        _isForUser = server is UserServer,
        super(key: key, child: child);

  static Head of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Head>()!;
  }

  set offlineMode(bool value) {
    //TODO
  }

  @override
  bool updateShouldNotify(Head oldWidget) {
    return false;
  }

}

class _ServerPointer {
  Server value;
  _ServerPointer(this.value);
}