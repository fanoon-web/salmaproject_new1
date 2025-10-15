import 'package:flutter/material.dart';
import 'package:salmaproject_new1/persentaion/cart/widget/quantity_button.dart';
import '../../common/widgets/text/basic_app_text.dart';
import '../../core/configs/theme/app_colors.dart';
import '../orders/OrdersProvider.dart';

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.grey.withValues(alpha: 0.1),
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              product['image'] ?? '',
              width: 80,
              height: 80,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BasicAppText(
                  title: product['name'] ?? '',
                  style: theme.textTheme.titleMedium?.copyWith(),
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),
                BasicAppText(
                  title: "\$${(product['price'] ?? 0).toStringAsFixed(2)}",
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.green[700],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    QuantityButton(
                      symbol: "-",
                      productId: productId,
                      onPressed: () {},
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BasicAppText(
                        title: "${product['quantity'] ?? 1}",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    QuantityButton(
                      symbol: "+",
                      productId: productId,
                      onPressed: () {},
                    ),
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
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
