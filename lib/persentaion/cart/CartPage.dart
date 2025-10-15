import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salmaproject_new1/persentaion/cart/product_crdered_Card.dart';
import '../../../../common/widgets/appbar/app_bar.dart';
import '../../../../core/assets/app_vectors.dart';
import '../../common/widgets/text/basic_app_text.dart';
import '../orders/OrdersProvider.dart';
import 'checkout.dart';
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
        title: Text(
          "Shopping Cart",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w400,
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
          BasicAppText(
            title: "Your cart is empty",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              color: Colors.blueGrey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
