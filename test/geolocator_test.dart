import 'package:geolocator/geolocator.dart' show Geolocator;
import 'package:test/test.dart';

void main() {
  test('geolocator', () {
    var distance = Geolocator.distanceBetween(48.86, 2.35, 52.53, 13.40);
    print(distance);
    expect(distance > 878000 && distance < 880000, isTrue);
  });
}