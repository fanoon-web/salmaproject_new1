import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class OrdersProvider with ChangeNotifier {
  final Box _ordersBox = Hive.box('orders');
  final Box _cartBox = Hive.box('cart');

  Map<dynamic, dynamic> get orders => _ordersBox.toMap();

  Map<dynamic, dynamic> get cart => _cartBox.toMap();

  void addToCart(
    String productId,
    String name,
    double price,
    int quantity,
    String image,
  ) {
    _cartBox.put(productId, {
      'name': name,
      'price': price,
      'quantity': quantity,
      'image': image,
    });
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartBox.delete(productId);
    notifyListeners();
  }

  void clearCart() {
    _cartBox.clear();
    notifyListeners();
  }

  void checkoutCart() {
    if (_cartBox.isEmpty) return;

    final orderId = "ORD${DateTime.now().millisecondsSinceEpoch}";
    double total = 0;

    _cartBox.toMap().forEach((key, value) {
      total += (value['price'] ?? 0) * (value['quantity'] ?? 1);
    });

    _ordersBox.put(orderId, {
      'date': DateTime.now().toIso8601String(),
      'total': total,
      'itemsCount': _cartBox.length,
      'products': _cartBox.toMap(),
    });

    clearCart();
  }
}
