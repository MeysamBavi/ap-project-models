
class Price {
  final int _value;

  const Price(this._value);

  int toInt() => _value;

  @override
  String toString() => '$_value';

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

}