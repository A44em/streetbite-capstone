import 'package:flutter_test/flutter_test.dart';
import 'package:streetbite/domain/entities/meal.dart';
import 'package:streetbite/presentation/blocs/cart_bloc.dart';

void main() {
  const meal = Meal(
      id: '1',
      name: 'Meal',
      image: '',
      category: 'Test',
      area: 'Test',
      instructions: '',
      price: 75);
  test('Cart events update items and total', () async {
    final cart = CartBloc();
    cart.add(CartItemAdded(meal));
    cart.add(CartItemAdded(meal));
    await cart.stream.firstWhere((items) => items.length == 2);
    expect(cart.total, 150);
    cart.add(CartItemRemoved(0));
    await cart.stream.firstWhere((items) => items.length == 1);
    expect(cart.total, 75);
    cart.add(CartCleared());
    await cart.stream.firstWhere((items) => items.isEmpty);
    expect(cart.total, 0);
    await cart.close();
  });
}
