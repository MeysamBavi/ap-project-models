import 'serializable.dart';
import 'editable.dart';
import 'server.dart';

class Comment with Serializable implements Editable {

  final Server server;
  final String restaurantID;
  final DateTime time;
  final int score;
  final String title;
  final String message;
  String? _reply;

  Comment({
    required this.server,
    required this.restaurantID,
    required this.score,
    required this.title,
    required this.message
})  : time = DateTime.now();

  String? get reply => _reply;

  set reply(String? value) {
    _reply = value;
    server.edit(this);
  }
}