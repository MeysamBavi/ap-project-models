import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  var pizza = Food(name: 'pizza', category: FoodCategory.FastFood, price: Price(25000));
  var burger = Food(name: 'burger', category: FoodCategory.FastFood, price: Price(20000));
  var sushi = Food(name: 'sushi', category: FoodCategory.SeaFood, price: Price(45000));
  var fish = Food(name: 'fish', category: FoodCategory.SeaFood, price: Price(30000));
  var kabab = Food(name: 'kabab', category: FoodCategory.Iranian, price: Price(15000));
  var kookoo = Food(name: 'kookoo', category: FoodCategory.Iranian, price: Price(10000));

  test('auto adding categories', () {
    var menu = FoodMenu();
    menu.addFood(pizza);
    menu.addFood(burger);
    expect(menu.categories, equals([FoodCategory.FastFood]));
  });

  test('auto adding categories', () {
    var menu = FoodMenu();
    menu.addFood(pizza);
    menu.addFood(burger);
    menu.addFood(sushi);
    menu.addFood(kabab);
    expect(menu.categories, containsAll(FoodCategory.values));
  });

  test('auto removing categories', () {
    var menu = FoodMenu();
    menu.addFood(pizza);
    menu.removeFood(pizza);
    expect(menu.categories, isEmpty);
    expect(menu.hasCategory(FoodCategory.FastFood), false);
  });

  test('returning identical reference', () {
    var menu = FoodMenu();
    menu.addFood(pizza);
    expect(menu.getFoods(pizza.category)?[0], equals(pizza));
  });

  test('returning identical reference', () {
    var menu = FoodMenu();
    menu.addFood(sushi);
    menu.addFood(kookoo);
    expect(menu.getFoods(kookoo.category)?[0], equals(kookoo));
  });

  test('identical reference', () {
    var menu = FoodMenu();
    var rice = Food(name: 'rice', category: FoodCategory.Iranian, price: Price(10000));
    menu.addFood(rice);
    rice.name = 'rice2';
    expect(menu.getFoods(rice.category)?[0].name, equals('rice2'));
  });

  test('remove', () {
    var menu = FoodMenu();
    var rice = Food(name: 'rice', category: FoodCategory.Iranian, price: Price(10000));
    menu.addFood(rice);
    menu.addFood(pizza);
    menu.removeFood(rice);
    expect(menu.getFoods(rice.category), equals(null));
  });

  test('remove', () {
    var menu = FoodMenu();
    menu.addFood(burger);
    menu.addFood(pizza);
    menu.removeFood(burger);
    expect(menu.getFoods(FoodCategory.FastFood), equals([pizza]));
  });

  test('remove sth that doesnt exist', () {
    var menu = FoodMenu();
    menu.addFood(pizza);
    menu.removeFood(fish);
    expect(menu.getFoods(fish.category), equals(null));
  });

  test('remove twice', () {
    var menu = FoodMenu();
    menu.addFood(pizza);
    menu.removeFood(pizza);
    menu.removeFood(pizza);
    expect(menu.getFoods(pizza.category), equals(null));
    expect(menu.categories, isEmpty);
  });

}
