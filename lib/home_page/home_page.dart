import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  // 🔹 جلب جميع المنتجات من فايربيس
  Future<List<Map<String, dynamic>>> _fetchProducts() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('products').get();
      return snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();
    } catch (e) {
      debugPrint("Firestore error: $e");
      return [];
    }
  }

  // ------------------- Drawer & Bottom Navigation -------------------
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

  // ------------------- Main Body -------------------
  Widget _getBody() {
    final favoriteProvider = context.watch<FavoriteProvider>();

    switch (_selectedDrawerIndex) {
    // 🏠 الصفحة الرئيسية (عرض المنتجات)
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
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final id = product['id'] ?? '';
                final name = product['name'] ?? 'منتج بدون اسم';
                final image = product['image'] ?? 'https://via.placeholder.com/150';
                final description = product['description'] ?? 'لا يوجد وصف';
                final price = product['price']?.toString() ?? 'غير محدد';
                final isFav = favoriteProvider.isFavorite(id);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(image, width: 70, height: 70, fit: BoxFit.cover),
                    ),
                    title: Text(name,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(description,
                            style: GoogleFonts.poppins(
                                fontSize: 13, color: Colors.grey[700])),
                        const SizedBox(height: 6),
                        Text("💰 السعر: \$${price}",
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700])),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        if (isFav) {
                          favoriteProvider.removeFavorite(id);
                        } else {
                          favoriteProvider.addFavorite(id, name);
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        );

    // 👤 الحساب
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

    // ⚙️ تسجيل الخروج
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

    // 💬 الدعم
      case 3:
        return const Center(
          child: Text('Help / Support Page', style: TextStyle(fontSize: 24)),
        );

      default:
        return const SizedBox();
    }
  }

  // ------------------- Build -------------------
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
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
       //   BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        ],
      ),
    );
  }
}
