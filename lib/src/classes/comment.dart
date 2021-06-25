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

  Comment.fromJson(Map<String, dynamic> json, Server server):
        server = server,
        restaurantID = json['restaurantID'],
        time = DateTime.fromMillisecondsSinceEpoch(int.parse(json['time'])),
        score = json['score'].toInt(),
        title = json['title'],
        message = json['message'],
        _reply = json['reply']
  {
    id = json['ID'];
  }

  Map<String, dynamic> toJson() => {
    'ID' : id,
    'restaurantID' : restaurantID,
    'time' : time.millisecondsSinceEpoch.toString(),
    'score' : score,
    'title' : title,
    'message' : message,
    'reply' : _reply,
  };
}