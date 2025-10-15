import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/appbar/app_bar.dart';
import '../../core/configs/theme/app_colors.dart';

/// ✅ مزود الحالة (Provider) لإدارة المفضلات
class FavoriteProvider with ChangeNotifier {
  final Box _box = Hive.box('favorites');

  /// قراءة جميع المفضلات
  Map<dynamic, dynamic> get favorites => _box.toMap();

  /// إضافة منتج للمفضلة مع جميع التفاصيل
  void addFavorite(
      String productId, String name, String image, String price, String description) {
    _box.put(productId, {
      'name': name,
      'image': image,
      'price': price,
      'description': description,
    });
    notifyListeners();
  }

  /// حذف منتج من المفضلة
  void removeFavorite(String productId) {
    _box.delete(productId);
    notifyListeners();
  }

  /// التحقق إذا المنتج مضاف
  bool isFavorite(String productId) => _box.containsKey(productId);
}

/// ✅ صفحة عرض المفضلات بتصميم احترافي
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favorites = favoriteProvider.favorites;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BasicAppbar(
          hideBack: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              "Favorites ",
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        body: favorites.isEmpty
            ? const Center(
          child: Text(
            "No Favorite Products Yet",
            style: TextStyle(fontSize: 18),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final entry = favorites.entries.elementAt(index);
            final productId = entry.key;
            final productValue = entry.value;

            Map productData;
            if (productValue is Map) {
              productData = productValue;
            } else {
              // دعم للبيانات القديمة المخزنة كنص فقط
              productData = {
                'name': productValue.toString(),
                'image': 'https://via.placeholder.com/150',
                'price': 'N/A',
                'description': '',
              };
            }

            final productName = productData['name'] ?? 'Unnamed';
            final productImage =
                productData['image'] ?? 'https://via.placeholder.com/150';
            final productPrice = productData['price'] ?? 'N/A';
            final productDescription = productData['description'] ?? '';

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 صورة المنتج
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
                    child: Image.network(
                      productImage,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),

                  // 🔹 معلومات المنتج
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            productDescription,
                            style: GoogleFonts.roboto(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "\$${productPrice.toString()}",
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 🔹 زر الحذف
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.redAccent, size: 28),
                    onPressed: () {
                      favoriteProvider.removeFavorite(productId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '$productName removed from favorites'),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
