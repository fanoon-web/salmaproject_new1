import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/widgets/appbar/app_bar.dart';
import '../../core/assets/app_vectors.dart';
import '../../core/configs/theme/app_colors.dart';
import 'OrdersProvider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final orders = ordersProvider.orders;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: BasicAppbar(
        hideBack: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            "My Orders",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.blueGrey[900],
            ),
          ),
        ),
      ),
      body: orders.isEmpty
          ? _ordersEmpty()
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final entry = orders.entries.elementAt(index);
          final orderId = entry.key;
          final order = entry.value;

          final date = order['date'] ?? 'N/A';
          final total = order['total'] ?? 0;
          final itemsCount = order['itemsCount'] ?? 0;
          final products = order['products'] as Map? ?? {};

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: OrderCard(
              orderId: orderId,
              date: date,
              total: total,
              itemsCount: itemsCount,
              products: products,
            ),
          );
        },
      ),
    );
  }

  Widget _ordersEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppVectors.cartBag, width: 140, height: 140),
          const SizedBox(height: 20),
          Text(
            "You have no orders yet",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.blueGrey[400],
            ),
          ),
        ],
      ),
    );
  }
}

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
            Text(
              "Order ID: $orderId",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.blueGrey[900],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Items: $itemsCount • Total: \$${total.toStringAsFixed(2)}",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.blueGrey[600],
              ),
            ),
          ],
        ),
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
                          Text(
                            product['name'] ?? '',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.blueGrey[900],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Qty: ${product['quantity']} • \$${(product['price'] ?? 0).toStringAsFixed(2)}",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.blueGrey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20, thickness: 1, color: Colors.grey),
              ],
            );
          }).toList(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Order Date: $date",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.blueGrey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
