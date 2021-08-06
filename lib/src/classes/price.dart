import 'discount.dart';

class Price {

  static const MAX = 1000000000;
  final int _value;
  const Price(int value)  : _value = value > MAX ? MAX : value;

  int toInt() => _value;

  @override
  String toString() => _separateEachNDigitsWithC(n: 3, c: ',', value: _value);

  Price operator +(Price other) => Price(_value + other.toInt());
  Price operator -(Price other) => Price(_value - other.toInt());
  Price operator *(Price other) => Price(_value * other.toInt());


  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Price && runtimeType == other.runtimeType &&
            _value == other._value);
  }

  @override
  int get hashCode => _value.hashCode;

  Price operator /(Price other) {
    int gcd = _value.toInt().gcd(other.toInt());
    int a = _value~/gcd;
    int b = _value~/gcd;
    return Price(a~/b);
  }

  static Price addAll(List<Price> prices) {
    int result = 0;
    for (var p in prices) {
      result += p.toInt();
    }
    return Price(result);
  }

  Price addTo(List<Price> prices) {
    prices.add(this);
    return Price.addAll(prices);
  }

  Price apply(Discount discount) {
    var value = (100 - discount.percent)/100 * this.toInt();
    return Price(value.round());
  }

}

String _separateEachNDigitsWithC({required int n, required String c, required int value}) {
  var buffer = StringBuffer();
  var initialLength = value.toString().length;
  for (var i = 0; i < initialLength; i++) {
    if ((initialLength - i) % n == 0 && i != 0) {
      buffer.write(c);
    }
    buffer.write(value.toString()[i]);
  }
  return buffer.toString();
}