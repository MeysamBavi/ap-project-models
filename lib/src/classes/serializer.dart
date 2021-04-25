import 'serializable.dart';
class Serializer {

  String createID(Serializable object) {
    // needs dev
    return object.hashCode.toString();
  }

  Serializer._() : super();

  static final _serializer = Serializer._();

  factory Serializer() {
    return _serializer;
  }

}