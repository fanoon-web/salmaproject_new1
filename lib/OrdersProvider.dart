import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// مزود الحالة لإدارة السلة والطلبات
class OrdersProvider with ChangeNotifier {
  final Box _ordersBox = Hive.box('orders'); // صندوق تخزين الطلبات
  final Box _cartBox = Hive.box('cart'); // صندوق تخزين السلة

  /// الحصول على جميع الطلبات
  Map<dynamic, dynamic> get orders => _ordersBox.toMap();

  /// الحصول على جميع منتجات السلة
  Map<dynamic, dynamic> get cart => _cartBox.toMap();

  /// إضافة منتج للسلة
  void addToCart(String productId, String name, double price, int quantity, String image) {
    _cartBox.put(productId, {
      'name': name,
      'price': price,
      'quantity': quantity,
      'image': image,
    });
    notifyListeners(); // تحديث الواجهة عند الإضافة
  }

  /// إزالة منتج من السلة
  void removeFromCart(String productId) {
    _cartBox.delete(productId);
    notifyListeners(); // تحديث الواجهة عند الحذف
  }

  /// تفريغ كامل السلة
  void clearCart() {
    _cartBox.clear();
    notifyListeners(); // تحديث الواجهة عند التفريغ
  }

  /// إنشاء طلب جديد من محتويات السلة (Checkout)
  void checkoutCart() {
    if (_cartBox.isEmpty) return; // إذا كانت السلة فارغة لا نفعل شيئاً

    final orderId = "ORD${DateTime.now().millisecondsSinceEpoch}";
    double total = 0;

    // حساب المجموع الكلي
    _cartBox.toMap().forEach((key, value) {
      total += (value['price'] ?? 0) * (value['quantity'] ?? 1);
    });

    // إضافة الطلب إلى صندوق الطلبات
    _ordersBox.put(orderId, {
      'date': DateTime.now().toIso8601String(),
      'total': total,
      'itemsCount': _cartBox.length,
      'products': _cartBox.toMap(), // حفظ كل منتجات السلة داخل الطلب
    });

    clearCart(); // تفريغ السلة بعد إتمام الطلب
  }
}
