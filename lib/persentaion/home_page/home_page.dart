import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salmaproject_new1/core/configs/theme/app_colors.dart';
import 'search_field.dart';
import 'carousel_slider.dart';
import 'categories.dart';
import 'favorite_provider.dart';
import 'filter_chip.dart';
import 'header.dart';
import '../../common/widgets/appbar/app_bar.dart';
import '../orders/OrdersProvider.dart';

class HomePage extends StatefulWidget {
  final String userEmail;
  const HomePage({super.key, required this.userEmail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  Future<List<Map<String, dynamic>>> _fetchProducts() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('products').get();
      return snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();
    } catch (e) {
      debugPrint("Firestore error: $e");
      return [];
    }
  }

  Widget _productCard(Map product, FavoriteProvider favProvider, OrdersProvider orderProvider) {
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
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                child: Image.network(image, height: 120, width: double.infinity, fit: BoxFit.cover),
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
                  child: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white),
                ),
              ),
              Positioned(
                bottom: -16,
                right: 8,
                child: ElevatedButton(
                  onPressed: () {
                    orderProvider.addToCart(id, name, double.tryParse(price) ?? 0, 1, image);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('$name added to cart'), duration: const Duration(seconds: 1)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.adminPrimary,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black)),
                const SizedBox(height: 4),
                Text("\$$price",
                    style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green[700])),
                const SizedBox(height: 4),
                Text(desc,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.grey[700])),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(rating, style: GoogleFonts.roboto(fontSize: 13, color: Colors.black)),
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

  Widget _getBody() {
    final favProvider = context.watch<FavoriteProvider>();
    final orderProvider = context.read<OrdersProvider>();

    if (_selectedDrawerIndex != 0) return const SizedBox();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No products yet"));

        final products = snapshot.data!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(userEmail: widget.userEmail),
              const SizedBox(height: 20),
              const SearchField(),
              const SizedBox(height: 12),
              const CustomFilterChips(),
              const SizedBox(height: 20),
              const CustomerCarouselSlider(),
              const SizedBox(height: 20),
              const Categories(),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.7),
                itemCount: products.length,
                itemBuilder: (context, index) => _productCard(products[index], favProvider, orderProvider),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BasicAppbar(
          hideBack: true,
          title: Text("Computer House",
              style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black)),
        ),
        body: _getBody(),
      ),
    );
  }
}
