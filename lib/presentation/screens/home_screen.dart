import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_localizations.dart';
import '../blocs/cart_bloc.dart';
import '../blocs/locale_cubit.dart';
import '../blocs/meal_cubit.dart';
import '../blocs/theme_cubit.dart';
import '../widgets/meal_card.dart';
import '../widgets/meal_image.dart';
import 'cart_screen.dart';
import 'meal_details_screen.dart';
import 'profile_screen.dart';
import 'vendor_map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.home),
        actions: [
          IconButton(
            tooltip: localizations.profile,
            onPressed: () => openProtectedProfile(context),
            icon: const Icon(Icons.person_outline),
          ),
          IconButton(
            tooltip: localizations.map,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VendorMapScreen()),
            ),
            icon: const Icon(Icons.map_outlined),
          ),
          IconButton(
            tooltip: localizations.language,
            onPressed: () => context.read<LocaleCubit>().toggle(),
            icon: const Icon(Icons.language),
          ),
          IconButton(
            tooltip: localizations.theme,
            onPressed: () => context.read<ThemeCubit>().toggle(),
            icon: const Icon(Icons.brightness_6),
          ),
          Semantics(
            identifier: 'open_cart',
            button: true,
            child: IconButton(
              tooltip: localizations.cart,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
              icon: Badge(
                label: Text('${context.watch<CartBloc>().state.length}'),
                child: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<MealCubit, MealState>(
        builder: (context, state) {
          if (state is MealLoading) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  Text(localizations.loading),
                ],
              ),
            );
          }
          if (state is MealFailure) {
            return Center(
              child: ElevatedButton(
                onPressed: () => context.read<MealCubit>().load(),
                child: Text(localizations.retry),
              ),
            );
          }

          final meals = (state as MealLoaded).meals;
          if (meals.isEmpty) {
            return Center(child: Text(localizations.mealUnavailable));
          }

          return LayoutBuilder(
            builder: (context, constraints) => ListView(
              children: [
                SizedBox(
                  height: 145,
                  child: PageView(
                    children: meals
                        .take(3)
                        .map(
                          (meal) => MealImage(url: meal.image),
                        )
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    localizations.offers,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: meals
                        .take(5)
                        .map(
                          (meal) => Padding(
                            padding: const EdgeInsets.all(8),
                            child: Chip(label: Text(meal.name)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Semantics(
                  identifier: 'meal_grid',
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: constraints.maxWidth > 700 ? 4 : 2,
                      childAspectRatio: .67,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return MealCard(
                        meal: meal,
                        addLabel: localizations.addToCart,
                        onOpen: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MealDetailsScreen(meal: meal),
                          ),
                        ),
                        onAdd: () {
                          context.read<CartBloc>().add(CartItemAdded(meal));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(localizations.addedToCart)),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
