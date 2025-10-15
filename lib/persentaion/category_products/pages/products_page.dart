import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/appbar/app_bar.dart';
import '../../home_page/favorite_provider.dart';
import '../../../core/configs/theme/app_colors.dart';

class ProductsPage extends StatefulWidget {
  final String categoryId;
  const ProductsPage({required this.categoryId, super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Future<List<Map<String, dynamic>>> _fetchProducts() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('categoryId', isEqualTo: widget.categoryId)
          .get();
      return snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();
    } catch (e) {
      debugPrint("Firestore error: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoriteProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const BasicAppbar(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("No products yet", style: theme.textTheme.bodyMedium),
            );
          }

          final products = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final id = product['id'] ?? '';
              final name = product['name'] ?? 'No Name';
              final image = product['image'] ?? 'https://via.placeholder.com/150';
              final price = product['price']?.toString() ?? 'N/A';
              final description = product['description'] ?? '';
              final rating = product['rating']?.toString() ?? '4.5';
              final isFav = favoriteProvider.isFavorite(id);

              return Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
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
                                favoriteProvider.removeFavorite(id);
                              } else {
                                favoriteProvider.addFavorite(id, name, image, price, description);
                              }
                            },
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : theme.iconTheme.color,
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
                          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text("\$$price", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.green[700])),
                          const SizedBox(height: 4),
                          Text(description, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 16),
                              const SizedBox(width: 4),
                              Text(rating, style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
