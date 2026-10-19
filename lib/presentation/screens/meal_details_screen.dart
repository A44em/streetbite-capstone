import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/firestore_service.dart';
import '../../domain/entities/meal.dart';
import '../../l10n/app_localizations.dart';
import '../blocs/cart_bloc.dart';
import '../widgets/meal_image.dart';
import 'cart_screen.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({required this.meal, super.key});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BlocConsumer<CartBloc, List<Meal>>(
      listenWhen: (previous, current) => current.length > previous.length,
      listener: (context, state) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.addedToCart)),
      ),
      builder: (context, cartItems) => Scaffold(
        appBar: AppBar(
          title: Text(localizations.details),
          actions: [
            IconButton(
              tooltip: localizations.saveFavourite,
              onPressed: () => _toggleFavourite(context, localizations),
              icon: const Icon(Icons.favorite_border),
            ),
            IconButton(
              tooltip: localizations.cart,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
              icon: Badge(
                label: Text('${cartItems.length}'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            MealImage(url: meal.image, height: 230),
            const SizedBox(height: 16),
            Text(
              meal.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text('${localizations.category}: ${meal.category}'),
            Text('${localizations.origin}: ${meal.area}'),
            const SizedBox(height: 20),
            Text(
              localizations.instructions,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(meal.instructions),
            const SizedBox(height: 20),
            Semantics(
              identifier: 'details_add_to_cart',
              button: true,
              child: FilledButton(
                onPressed: () =>
                    context.read<CartBloc>().add(CartItemAdded(meal)),
                child: Text(localizations.addToCart),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleFavourite(
    BuildContext context,
    AppLocalizations localizations,
  ) async {
    try {
      await FirestoreService.instance.toggleFavourite(meal);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.favourites)),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.error)),
        );
      }
    }
  }
}
