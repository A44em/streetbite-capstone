import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/firestore_service.dart';
import '../../domain/services/payment_method.dart';
import '../../l10n/app_localizations.dart';
import '../blocs/cart_bloc.dart';
import '../../domain/entities/meal.dart';

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
        body: BlocConsumer<CartBloc, List<Meal>>(listener: (context, state) {
          if (state.isEmpty) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(l.emptyCartNotice)));
          }
        }, builder: (context, items) {
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
                      return ListTile(
                          leading: Image.network(meal.image,
                              width: 54,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.restaurant)),
                          title: Text(meal.name),
                          subtitle: Text(meal.price.toStringAsFixed(2)),
                          trailing: IconButton(
                              tooltip: l.remove,
                              onPressed: () => cart.add(CartItemRemoved(i)),
                              icon: const Icon(Icons.delete_outline)));
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
                            DropdownMenuItem(value: 'card', child: Text(l.card))
                          ],
                          onChanged:
                              busy ? null : (v) => setState(() => method = v!)),
                      FilledButton(
                          onPressed: busy ? null : checkout,
                          child: Text(l.placeOrder))
                    ]))
          ]);
        }));
  }
}
