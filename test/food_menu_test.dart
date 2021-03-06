import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  var server = OwnerServer();
  var pizza = Food(name: 'pizza', category: FoodCategory.FastFood, price: Price(25000), server: server);
  var burger = Food(name: 'burger', category: FoodCategory.FastFood, price: Price(20000), server: server);
  var sushi = Food(name: 'sushi', category: FoodCategory.SeaFood, price: Price(45000), server: server);
  var fish = Food(name: 'fish', category: FoodCategory.SeaFood, price: Price(30000), server: server);
  var kabab = Food(name: 'kabab', category: FoodCategory.Iranian, price: Price(15000), server: server);
  var kookoo = Food(name: 'kookoo', category: FoodCategory.Iranian, price: Price(10000), server: server);

  test('auto adding categories', () {
    var menu = FoodMenu(server);
    menu.addFood(pizza);
    menu.addFood(burger);
    expect(menu.categories, equals([FoodCategory.FastFood]));
  });

  test('auto adding categories', () {
    var menu = FoodMenu(server);
    menu.addFood(pizza);
    menu.addFood(burger);
    menu.addFood(sushi);
    menu.addFood(kabab);
    expect(menu.categories, containsAll(FoodCategory.values));
  });

  test('auto removing categories', () {
    var menu = FoodMenu(server);
    menu.addFood(pizza);
    menu.removeFood(pizza);
    expect(menu.categories, isEmpty);
    expect(menu.hasCategory(FoodCategory.FastFood), false);
  });

  test('returning identical reference', () {
    var menu = FoodMenu(server);
    menu.addFood(pizza);
    expect(menu.getFoods(pizza.category)?[0], equals(pizza));
  });

  test('returning identical reference', () {
    var menu = FoodMenu(server);
    menu.addFood(sushi);
    menu.addFood(kookoo);
    expect(menu.getFoods(kookoo.category)?[0], equals(kookoo));
  });

  test('identical reference', () {
    var menu = FoodMenu(server);
    var rice = Food(name: 'rice', category: FoodCategory.Iranian, price: Price(10000), server: server);
    menu.addFood(rice);
    rice.name = 'rice2';
    expect(menu.getFoods(rice.category)?[0].name, equals('rice2'));
  });

  test('remove', () {
    var menu = FoodMenu(server);
    var rice = Food(name: 'rice', category: FoodCategory.Iranian, price: Price(10000), server: server);
    menu.addFood(rice);
    menu.addFood(pizza);
    menu.removeFood(rice);
    expect(menu.getFoods(rice.category), isEmpty);
  });

  test('remove', () {
    var menu = FoodMenu(server);
    menu.addFood(burger);
    menu.addFood(pizza);
    menu.removeFood(burger);
    expect(menu.getFoods(FoodCategory.FastFood), equals([pizza]));
  });

  test('remove sth that doesnt exist', () {
    var menu = FoodMenu(server);
    menu.addFood(pizza);
    menu.removeFood(fish);
    expect(menu.getFoods(fish.category), isEmpty);
  });

  test('remove twice', () {
    var menu = FoodMenu(server);
    menu.addFood(pizza);
    menu.removeFood(pizza);
    menu.removeFood(pizza);
    expect(menu.getFoods(pizza.category), isEmpty);
    expect(menu.categories, isEmpty);
  });

  test('order of categories', (){
    var menu1 = FoodMenu(server);
    var menu2 = FoodMenu(server);
    menu1.addFood(pizza);
    menu1.addFood(sushi);
    menu1.addFood(kookoo);
    menu2.addFood(kookoo);
    menu2.addFood(pizza);
    menu2.addFood(sushi);
    expect(menu1.categories.join(' ') == menu2.categories.join(' '), isTrue);
  });

  test('order of categories', (){
    var menu1 = FoodMenu(server);
    var menu2 = FoodMenu(server);
    menu1.addFood(pizza);
    menu1.addFood(sushi);
    menu2.addFood(pizza);
    menu2.addFood(sushi);
    expect(menu1.categories.join(' ') == menu2.categories.join(' '), isTrue);
  });

}
