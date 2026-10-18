import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/meal.dart';

sealed class CartEvent {}
class CartItemAdded extends CartEvent { CartItemAdded(this.meal); final Meal meal; }
class CartItemRemoved extends CartEvent { CartItemRemoved(this.index); final int index; }
class CartCleared extends CartEvent {}

/// Event-driven cart used by home, details and checkout screens.
class CartBloc extends Bloc<CartEvent, List<Meal>> {
  CartBloc() : super(const []) {
    on<CartItemAdded>((event, emit) => emit(List.unmodifiable([...state, event.meal])));
    on<CartItemRemoved>((event, emit) {
      if (event.index < 0 || event.index >= state.length) return;
      final next = [...state]..removeAt(event.index);
      emit(List.unmodifiable(next));
    });
    on<CartCleared>((event, emit) => emit(const []));
  }
  double get total => state.fold<double>(0, (sum, meal) => sum + meal.price);
}
