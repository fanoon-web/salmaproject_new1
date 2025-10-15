import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../common/widgets/appbar/app_bar.dart';
import '../../../core/assets/app_vectors.dart';
import '../../../core/configs/theme/app_colors.dart';
import 'OrdersProvider.dart';
import 'ordercard.dart';


class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final orders = ordersProvider.orders;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BasicAppbar(
        hideBack: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            "My Orders",
            style: GoogleFonts.roboto(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color:AppColors.adminDarkBackground,
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
            style: GoogleFonts.roboto(
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

