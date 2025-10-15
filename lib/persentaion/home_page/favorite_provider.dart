import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavoriteProvider with ChangeNotifier {
  final Box _box = Hive.box('favorites');

  Map<dynamic, dynamic> get favorites => _box.toMap();

  void addFavorite(
    String productId,
    String name,
    String image,
    String price,
    String description,
  ) {
    _box.put(productId, {
      'name': name,
      'image': image,
      'price': price,
      'description': description,
    });
    notifyListeners();
  }

  void removeFavorite(String productId) {
    _box.delete(productId);
    notifyListeners();
  }

  bool isFavorite(String productId) => _box.containsKey(productId);
}
