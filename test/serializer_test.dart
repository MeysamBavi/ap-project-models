import 'package:test/test.dart';
import '../lib/src/classes/serializer.dart';

void main() {
  var serializer = Serializer();

  test('id validator', () {
    expect(serializer.isIDValid('1234-ABCD'), isTrue);
  });

  test('id validator', () {
    expect(serializer.isIDValid('F-1A34-AB00'), isTrue);
  });

  test('id validator', () {
    expect(serializer.isIDValid('M-0000-A987'), isTrue);
  });

  test('id validator', () {
    expect(serializer.isIDValid('O-0000-A987'), isTrue);
  });

  test('id validator', () {
    expect(serializer.isIDValid('1234-ABCG'), isFalse);
  });

  test('id validator', () {
    expect(serializer.isIDValid('Z-1234-ABCD'), isFalse);
  });

  test('id validator', () {
    expect(serializer.isIDValid('F-1234-ABC'), isFalse);
  });

  test('id validator', () {
    expect(serializer.isIDValid('123-ABCD'), isFalse);
  });

  test('id validator', () {
    expect(serializer.isIDValid('123-ABC'), isFalse);
  });

  test('id validator', () {
    expect(serializer.isIDValid('R-12345678'), isFalse);
  });

  test('id validator', () {
    expect(serializer.isIDValid('1234567C'), isFalse);
  });

}