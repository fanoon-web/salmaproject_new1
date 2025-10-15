
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/widgets/text/basic_app_text.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String date;
  final double total;
  final int itemsCount;
  final Map products;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.date,
    required this.total,
    required this.itemsCount,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      child: ExpansionTile(
        initiallyExpanded: false,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BasicAppText(
              title:  "Order ID: $orderId",
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w500,color: Colors.blueGrey[900],
              ),
            ),

            const SizedBox(height: 4),
            BasicAppText(
              title:"Items: $itemsCount • Total: \$${total.toStringAsFixed(2)}",
              style: theme.textTheme.displaySmall?.copyWith( fontSize: 14,
                fontWeight: FontWeight.w500,color: Colors.blueGrey[600],
              ),),],),
        children: [
          ...products.entries.map((entry) {
            final product = entry.value;
            return Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product['image'] ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BasicAppText(
                            title:  product['name'] ?? '',
                            style: theme.textTheme.displaySmall?.copyWith( fontSize: 14,
                              fontWeight: FontWeight.w500,color: Colors.blueGrey[900],
                            ),
                          ),

                          const SizedBox(height: 2),

                          BasicAppText(
                            title:    "Qty: ${product['quantity']} • \$${(product['price'] ?? 0).toStringAsFixed(2)}",
                            style: theme.textTheme.displaySmall?.copyWith( fontSize: 13,
                              fontWeight: FontWeight.w500,color: Colors.blueGrey[500],

                            ),),],),),],),
                const Divider(height: 20, thickness: 1, color: Colors.grey),
              ],
            );
          }).toList(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: BasicAppText(
              title:   "Order Date: $date",
              style: theme.textTheme.displaySmall?.copyWith( fontSize: 12,
                fontWeight: FontWeight.w500,color: Colors.blueGrey[400],
              ),
            ),

          ),
        ],
      ),
    );
  }
}