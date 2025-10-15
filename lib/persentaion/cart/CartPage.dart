import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../common/widgets/appbar/app_bar.dart';
import '../../../../core/assets/app_vectors.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../orders/OrdersProvider.dart';
import 'checkout_success_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final cart = ordersProvider.cart;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: BasicAppbar(
        hideBack: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            "Shopping Cart",
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
      body: cart.isEmpty
          ? _cartIsEmpty(theme)
          : Stack(
        children: [
          _productsList(cart, ordersProvider, theme),
          Align(
            alignment: Alignment.bottomCenter,
            child: Checkout(
              cart: cart,
              onCheckout: () {
                ordersProvider.checkoutCart();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CheckoutSuccessPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _productsList(Map cart, OrdersProvider provider, ThemeData theme) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 120),
      itemCount: cart.length,
      itemBuilder: (context, index) {
        final entry = cart.entries.elementAt(index);
        final productId = entry.key;
        final product = entry.value;

        return ProductOrderedCard(
          productId: productId,
          product: product,
          provider: provider,
          theme: theme,
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 16),
    );
  }

  Widget _cartIsEmpty(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppVectors.cartBag, width: 120, height: 120),
          const SizedBox(height: 20),
          Text(
            "Your cart is empty",
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.blueGrey[300]),
          ),
        ],
      ),
    );
  }
}

class ProductOrderedCard extends StatelessWidget {
  final String productId;
  final Map product;
  final OrdersProvider provider;
  final ThemeData theme;

  const ProductOrderedCard({
    super.key,
    required this.productId,
    required this.product,
    required this.provider,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey.withOpacity(0.1), offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              product['image'] ?? '',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product['name'] ?? '', style: theme.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text("\$${(product['price'] ?? 0).toStringAsFixed(2)}",
                    style: theme.textTheme.titleSmall?.copyWith(color: Colors.green[700])),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _quantityButton("-", productId),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("${product['quantity'] ?? 1}", style: theme.textTheme.bodySmall),
                    ),
                    _quantityButton("+", productId),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => provider.removeFromCart(productId),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
              child: const Icon(Icons.delete, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(String symbol, String productId) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.thirdBackground,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Text(symbol, style: theme.textTheme.bodyMedium),
      ),
    );
  }
}

class Checkout extends StatelessWidget {
  final Map cart;
  final VoidCallback onCheckout;

  const Checkout({super.key, required this.cart, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double total = 0;
    cart.forEach((key, value) {
      total += (value['price'] ?? 0) * (value['quantity'] ?? 1);
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [BoxShadow(blurRadius: 15, color: Colors.grey.withOpacity(0.2), offset: const Offset(0, -5))],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total: \$${total.toStringAsFixed(2)}", style: theme.textTheme.titleMedium),
          ElevatedButton(
            onPressed: onCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.adminPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              elevation: 6,
            ),
            child: Text("Checkout", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
