class Address {

  double latitude;
  double longitude;
  String text;
  String name;

  Address({
    this.text = 'blank address',
    this.name = 'blank name',
    this.latitude = 0,
    this.longitude = 0,
});

  @override
  String toString() => text;

  Map<String, dynamic> toJson() => {
    'latitude' : latitude,
    'longitude' : longitude,
    'text' : text,
    'name' : name
  };

}