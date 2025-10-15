import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/configs/theme/app_colors.dart';
import '../orders/OrdersProvider.dart';
import 'favorite_provider.dart';

class ProductCard extends StatelessWidget {
  final Map product;
  final FavoriteProvider favProvider;
  final OrdersProvider orderProvider;

  const ProductCard({
    super.key,
    required this.product,
    required this.favProvider,
    required this.orderProvider,
  });

  @override
  Widget build(BuildContext context) {
    final id = product['id'] ?? '';
    final name = product['name'] ?? 'No Name';
    final desc = product['description'] ?? '';
    final image = product['image'] ?? 'https://via.placeholder.com/150';
    final price = product['price']?.toString() ?? '0';
    final rating = product['rating']?.toString() ?? '4.5';
    final isFav = favProvider.isFavorite(id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    if (isFav) {
                      favProvider.removeFavorite(id);
                    } else {
                      favProvider.addFavorite(id, name, image, price, desc);
                    }
                  },
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: -16,
                right: 8,
                child: ElevatedButton(
                  onPressed: () {
                    orderProvider.addToCart(
                      id,
                      name,
                      double.tryParse(price) ?? 0,
                      1,
                      image,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$name added to cart'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.adminPrimary,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$$price",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
