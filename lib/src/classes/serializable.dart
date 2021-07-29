mixin Serializable {
  String? _id;

  String? get id => _id;

  set id(String? value) {
    if (_id != null) {
      throw Exception('Re-assigning id for object of type ${this.runtimeType}.');
    }
    _id = value;
  }
}