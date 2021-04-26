import 'serializable.dart';
import 'editable.dart';
import 'server.dart';

class Comment with Serializable implements Editable {

  final Server server;
  final String restaurantID;
  final DateTime time;
  final double score;
  final String title;
  final String message;
  String? _response;

  Comment({
    required this.server,
    required this.restaurantID,
    required this.score,
    required this.title,
    required this.message
})  : time = DateTime.now();

  String? get response => _response;

  set response(String? value) {
    _response = value;
    server.edit(this);
  }
}