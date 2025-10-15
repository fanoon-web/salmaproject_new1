import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salmaproject_new1/core/configs/theme/app_colors.dart';
import 'package:salmaproject_new1/home_page/search_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../OrdersProvider.dart';
import '../common/widgets/appbar/app_bar.dart';
import '../favorite_provider.dart';

import 'carousel_slider.dart';
import 'categories.dart';
import 'filter_chip.dart';
import 'header.dart';

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
      final snapshot =
      await FirebaseFirestore.instance.collection('products').get();
      return snapshot.docs
          .map((doc) => {"id": doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      debugPrint("Firestore error: $e");
      return [];
    }
  }

  void _onDrawerTapped(int index) {
    setState(() {
      _selectedDrawerIndex = index;
    });
    Navigator.pop(context);
  }

  Widget _getBody() {
    final favoriteProvider = context.watch<FavoriteProvider>();
    final ordersProvider = context.read<OrdersProvider>();

    switch (_selectedDrawerIndex) {
      case 0:
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("لا توجد منتجات حالياً"));
            }

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
                  CustomFilterChips(),
                  const SizedBox(height: 20),
                  const CustomerCarouselSlider(),
                  const SizedBox(height: 20),
                  const SizedBox(height: 12),
                  Categories(),
                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.70,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final id = product['id'] ?? '';
                      final name = product['name'] ?? 'No Name';
                      final desc = product['description'] ?? 'No description';
                      final image =
                          product['image'] ?? 'https://via.placeholder.com/150';
                      final price = product['price']?.toString() ?? '0';
                      final rating = product['rating']?.toString() ?? '4.5';
                      final isFav = favoriteProvider.isFavorite(id);

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
                                // زر المفضلة
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (isFav) {
                                        favoriteProvider.removeFavorite(id);
                                      } else {
                                        favoriteProvider.addFavorite(
                                          id,
                                          name,
                                          image,
                                          price,
                                          desc,
                                        );
                                      }
                                    },
                                    child: Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFav ? Colors.red : Colors.white,
                                    ),
                                  ),
                                ),
                                // زر Add to Cart دائري
                                Positioned(
                                  bottom: -16,
                                  right: 8,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      ordersProvider.addToCart(
                                        id,
                                        name,
                                        double.tryParse(price) ?? 0,
                                        1,
                                        image,
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('$name added to cart'),
                                          duration:
                                          const Duration(seconds: 1),
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
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "\$$price",
                                    style: GoogleFonts.poppins(
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
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        rating,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
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
                    },
                  ),
                ],
              ),
            );
          },
        );

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: BasicAppbar(
            hideBack: true,
            title: Column(
              children: [
                Text(
                  "Computer House",
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          body: _getBody(),
        ),
      ),
    );
  }
}
