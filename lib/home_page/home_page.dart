import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../favorite_provider.dart';
import '../main.dart' hide FavoriteProvider;

class HomePage extends StatefulWidget {
  final String userEmail;
  const HomePage({super.key, required this.userEmail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;
  int _selectedBottomIndex = 0;

  Future<List<Map<String, dynamic>>> _fetchProducts() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('products').get();
      return snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();
    } catch (e) {
      debugPrint("Firestore error: $e");
      return [];
    }
  }

  void _onBottomTapped(int index) {
    setState(() {
      _selectedBottomIndex = index;
    });
  }

  void _onDrawerTapped(int index) {
    setState(() {
      _selectedDrawerIndex = index;
    });
    Navigator.pop(context);
  }

  Widget _getBody() {
    final favoriteProvider = context.watch<FavoriteProvider>();

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
                  // 🔹 Carousel Slider
                  const CustomerCarouselSlider(),

                  const SizedBox(height: 20),

                  // 🔹 Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Clearance Sales",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(height: 8),
                              Text("Up to 50%",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                        ),
                        Image.network(
                          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-14-pro-model-unselect-gallery-1-202209?wid=5120&hei=2880&fmt=jpeg&qlt=90&.v=1660753619946',
                          width: 80,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Categories
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip("All", true),
                        _buildCategoryChip("Smartphones", false),
                        _buildCategoryChip("Headphones", false),
                        _buildCategoryChip("Laptops", false),
                        _buildCategoryChip("Accessories", false),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Product Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      final image = product['image'] ?? 'https://via.placeholder.com/150';
                      final price = product['price']?.toString() ?? 'N/A';
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
                            )
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
                                        favoriteProvider.addFavorite(id, name);
                                      }
                                    },
                                    child: Icon(
                                      isFav ? Icons.favorite : Icons.favorite_border,
                                      color: isFav ? Colors.red : Colors.white,
                                    ),
                                  ),
                                )
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
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      )),
                                  const SizedBox(height: 4),
                                  Text("\$${price}",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.green[700],
                                      )),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.orange, size: 16),
                                      const SizedBox(width: 4),
                                      Text(rating,
                                          style: GoogleFonts.poppins(fontSize: 13)),
                                    ],
                                  ),
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

      case 1:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Account',
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('Email: ${widget.userEmail}', style: const TextStyle(fontSize: 18)),
            ],
          ),
        );

      case 2:
        return Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('Logout',
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        );

      case 3:
        return const Center(
          child: Text('Help / Support Page', style: TextStyle(fontSize: 24)),
        );

      default:
        return const SizedBox();
    }
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? const Color(0xFF1565C0) : Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Text(
                'Menu',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => _onDrawerTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Account'),
              onTap: () => _onDrawerTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings / Logout'),
              onTap: () => _onDrawerTapped(2),
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () => _onDrawerTapped(3),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_open_outlined, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomIndex,
        onTap: _onBottomTapped,
        selectedItemColor: const Color(0xFF1565C0),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
    );
  }
}

// 🔸 Carousel Slider Component
class CustomerCarouselSlider extends StatelessWidget {
  const CustomerCarouselSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> assetImages = const [
      'assets/anmation/Carousel1.jpeg',
      'assets/anmation/Carousel2.jpeg',
      'assets/anmation/Carousel3.jpeg',
      'assets/anmation/Carousel4.jpeg',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 180,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        viewportFraction: 0.9,
      ),
      items: assetImages.map((path) {
        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                path,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  );
                },
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
