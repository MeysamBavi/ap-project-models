import 'package:flutter/material.dart';
import '../../models.dart';

class Head extends InheritedWidget {

  final Server server;

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