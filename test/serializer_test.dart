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

}