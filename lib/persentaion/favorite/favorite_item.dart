import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home_page/favorite_provider.dart';


class FavoriteItem extends StatelessWidget {
  final String productId;
  final Map productData;
  final FavoriteProvider favoriteProvider;

  const FavoriteItem({
    Key? key,
    required this.productId, required this.productData, required this.favoriteProvider,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productName = productData['name'] ?? 'Unnamed';
    final productImage = productData['image'] ?? 'https://via.placeholder.com/150';
    final productPrice = productData['price'] ?? 'N/A';
    final productDescription = productData['description'] ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), bottomLeft: Radius.circular(18),),

            child: Image.network(
              productImage, width: 100, height: 100, fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 50),),),

        Expanded(child: Padding(padding: const EdgeInsets.all(12),
          child: Column(spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
             productName, style: GoogleFonts.roboto(fontSize: 16,
             fontWeight: FontWeight.w600,), maxLines: 1,
             overflow: TextOverflow.ellipsis,),

                  Text(
                    productDescription, style: GoogleFonts.roboto(fontSize: 13, color: Colors.grey[700],), maxLines: 2, overflow: TextOverflow.ellipsis,),

                  Text(
                    "\$${productPrice.toString()}", style: GoogleFonts.roboto(fontSize: 15, color: Colors.green[700], fontWeight: FontWeight.w600,),),],),),),

          IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 28,
            ),
            onPressed: () {favoriteProvider.removeFavorite(productId);ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$productName removed from favorites'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
