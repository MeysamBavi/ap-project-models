import 'serializer.dart';
mixin Serializable {
  String? _id;
  String? get id => _id;
  void serialize(Serializer serializer) {
    if (_id == null) {
      _id = serializer.createID(this);
    }
  }
}