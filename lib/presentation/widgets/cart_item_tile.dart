import 'package:flutter/material.dart';

import '../../domain/entities/meal.dart';
import 'meal_image.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    required this.meal,
    required this.currencyLabel,
    required this.removeLabel,
    required this.onRemove,
    super.key,
  });

  final Meal meal;
  final String currencyLabel;
  final String removeLabel;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: MealImage(url: meal.image, width: 54),
        title: Text(meal.name),
        subtitle: Text('${meal.price.toStringAsFixed(2)} $currencyLabel'),
        trailing: Semantics(
          identifier: 'remove_cart_item_${meal.id}',
          button: true,
          child: IconButton(
            tooltip: removeLabel,
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline),
          ),
        ),
      );
}
