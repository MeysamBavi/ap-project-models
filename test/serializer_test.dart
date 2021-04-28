import 'package:test/test.dart';
import 'package:models/models.dart';
void main() {
  var server = Server();
  test('food id', () {
    var food1 = Food(name: 'asd', category: FoodCategory.Iranian, price: Price(12), server: server);
    food1.serialize(server.serializer);
    var food2 = Food(name: 'fgh', category: FoodCategory.Iranian, price: Price(13), server: server);
    food2.serialize(server.serializer);
    print(food1.id);
    print(food2.id);
    expect(food1.id == food2.id, isFalse);
  });

  test('re-serialize', (){
    var food = Food(name: 'asd', category: FoodCategory.Iranian, price: Price(12), server: server);
    food.serialize(server.serializer);
    var id1 = food.id;
    print(id1);
    food.serialize(server.serializer);
    var id2 = food.id;
    print(id2);
    expect(id1 == id2, isTrue);
  });

  test('id validator', () {
    expect(server.isIDValid('1234-ABCD'), isTrue);
  });

  test('id validator', () {
    expect(server.isIDValid('F-1A34-AB00'), isTrue);
  });

  test('id validator', () {
    expect(server.isIDValid('M-0000-A987'), isTrue);
  });

  test('id validator', () {
    expect(server.isIDValid('O-0000-A987'), isTrue);
  });

  test('id validator', () {
    expect(server.isIDValid('1234-ABCG'), isFalse);
  });

  test('id validator', () {
    expect(server.isIDValid('Z-1234-ABCD'), isFalse);
  });

  test('id validator', () {
    expect(server.isIDValid('F-1234-ABC'), isFalse);
  });

  test('id validator', () {
    expect(server.isIDValid('123-ABCD'), isFalse);
  });

  test('id validator', () {
    expect(server.isIDValid('123-ABC'), isFalse);
  });

  test('id validator', () {
    expect(server.isIDValid('R-12345678'), isFalse);
  });

  test('id validator', () {
    expect(server.isIDValid('1234567C'), isFalse);
  });

}