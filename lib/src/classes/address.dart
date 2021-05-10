class Address {

  double latitude;
  double longitude;
  String text;

  Address({
    this.text = 'blank address',
    this.latitude = 0,
    this.longitude = 0,
});

  @override
  String toString() => text;

}