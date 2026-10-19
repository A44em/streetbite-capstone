import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/firestore_service.dart';
import '../../domain/entities/meal.dart';
import '../../domain/services/payment_method.dart';
import '../../l10n/app_localizations.dart';
import '../blocs/cart_bloc.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool busy = false;
  String method = 'cash';
  Future<void> checkout() async {
    final cart = context.read<CartBloc>();
    final l = AppLocalizations.of(context)!;
    final payment = method == 'cash' ? CashPayment() : DemoCardPayment();
    if (!await payment.authorize(cart.total)) {
      return;
    }
    setState(() => busy = true);
    try {
      await FirestoreService.instance
          .placeOrder(cart.state, paymentMethod: payment.code);
      if (!mounted) {
        return;
      }
      cart.add(CartCleared());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.orderSuccess)));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.orderFailed)));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(title: Text(l.cart)),
        body: BlocListener<CartBloc, List<Meal>>(
          listenWhen: (previous, current) =>
              previous.isNotEmpty && current.isEmpty,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(l.emptyCartNotice)));
          },
          child: BlocBuilder<CartBloc, List<Meal>>(
            builder: (context, items) {
              final cart = context.read<CartBloc>();
              if (items.isEmpty) {
                return Center(child: Text(l.emptyCart));
              }
              return Column(children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          final meal = items[i];
                          return CartItemTile(
                            meal: meal,
                            currencyLabel: l.priceUnit,
                            removeLabel: l.remove,
                            onRemove: () => cart.add(CartItemRemoved(i)),
                          );
                        })),
                Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(l.demoPrices,
                              style: Theme.of(context).textTheme.bodySmall),
                          Text('${l.total}: ${cart.total.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleLarge),
                          DropdownButton<String>(
                              isExpanded: true,
                              value: method,
                              items: [
                                DropdownMenuItem(
                                    value: 'cash', child: Text(l.cash)),
                                DropdownMenuItem(
                                    value: 'card', child: Text(l.card))
                              ],
                              onChanged: busy
                                  ? null
                                  : (v) => setState(() => method = v!)),
                          FilledButton(
                              onPressed: busy ? null : checkout,
                              child: Text(l.placeOrder))
                        ]))
              ]);
            },
          ),
        ));
  }
}
