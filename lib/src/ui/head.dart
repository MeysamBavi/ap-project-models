import 'package:flutter/material.dart';
import '../../src/classes/server.dart';
import '../../src/classes/user_server.dart';
import '../../src/classes/owner_server.dart';

class Head extends InheritedWidget {

  final Server server;

  UserServer get userServer {
    if (server is! UserServer) throw Exception('Illegal use of getter for UserServer.');
    return server as UserServer;
  }

  OwnerServer get ownerServer {
    if (server is! OwnerServer) throw Exception('Illegal use of getter for OwnerServer.');
    return server as OwnerServer;
  }

  Head({
    Key? key,
    required Widget child,
    required this.server,
})  : super(key: key, child: child);

  static Head of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Head>()!;
  }

  @override
  bool updateShouldNotify(Head oldWidget) {
    return false;
  }

}