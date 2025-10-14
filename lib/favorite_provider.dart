import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

/// ✅ مزود الحالة (Provider) لإدارة المفضلات
class FavoriteProvider with ChangeNotifier {
  final Box _box = Hive.box('favorites');

  /// قراءة المفضلات كلها
  Map<dynamic, dynamic> get favorites => _box.toMap();

  /// إضافة منتج للمفضلة
  void addFavorite(String productId, String productName) {
    _box.put(productId, productName);
    notifyListeners();
  }

  /// حذف منتج من المفضلة
  void removeFavorite(String productId) {
    _box.delete(productId);
    notifyListeners();
  }

  /// التحقق إذا المنتج مضاف
  bool isFavorite(String productId) {
    return _box.containsKey(productId);
  }
}

/// ✅ صفحة عرض المفضلات
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("المفضلة"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: favoriteProvider.favorites.isEmpty
          ? const Center(
        child: Text(
          "لا توجد عناصر في المفضلة",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView(
        children: favoriteProvider.favorites.entries.map((entry) {
          final productId = entry.key;
          final productName = entry.value;

          return Card(
            margin:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(productName),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  favoriteProvider.removeFavorite(productId);
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
