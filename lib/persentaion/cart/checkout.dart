import 'package:flutter/material.dart';
import '../../common/widgets/button/basic_app_button.dart';
import '../../common/widgets/text/basic_app_text.dart';

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
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BasicAppText(
            title: "Total: \$${total.toStringAsFixed(2)}",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          BasicAppButton(
            onPressed: onCheckout,
            title: "Checkout",
            width: 30,
            height: 50,
          ),
        ],
      ),
    );
  }
}
