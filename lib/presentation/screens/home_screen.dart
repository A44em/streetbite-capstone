import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_localizations.dart';
import '../blocs/cart_bloc.dart';
import '../blocs/locale_cubit.dart';
import '../blocs/meal_cubit.dart';
import '../blocs/theme_cubit.dart';
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
          IconButton(
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
                          (meal) => Image.network(
                            meal.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.restaurant),
                          ),
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
                GridView.builder(
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
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MealDetailsScreen(meal: meal),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Image.network(
                                meal.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.fastfood),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                meal.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(meal.category, maxLines: 1),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                context.read<CartBloc>().add(
                                      CartItemAdded(meal),
                                    );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(localizations.addToCart),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: Text(localizations.addToCart),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
