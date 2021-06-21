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

  Address.fromJson(Map<String, dynamic> json):
        text = json['text'],
        name = json['name'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  @override
  String toString() => text;

  Map<String, dynamic> toJson() => {
    'latitude' : latitude,
    'longitude' : longitude,
    'text' : text,
    'name' : name
  };

}