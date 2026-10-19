import 'package:flutter/material.dart';

import '../../domain/entities/meal.dart';
import 'meal_image.dart';

class MealCard extends StatelessWidget {
  const MealCard({
    required this.meal,
    required this.addLabel,
    required this.onOpen,
    required this.onAdd,
    super.key,
  });

  final Meal meal;
  final String addLabel;
  final VoidCallback onOpen;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Semantics(
        identifier: 'meal_card_${meal.id}',
        button: true,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onOpen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: MealImage(url: meal.image)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    meal.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(meal.category, maxLines: 1),
                ),
                Semantics(
                  identifier: 'add_to_cart_${meal.id}',
                  button: true,
                  child: TextButton.icon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add),
                    label: Text(addLabel),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
