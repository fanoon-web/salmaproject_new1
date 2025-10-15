// class Order {
//   final String id;
//   final String date;
//   final double total;
//   final int itemsCount;
//   final List<OrderProduct> products;
//
//   Order({
//     required this.id,
//     required this.date,
//     required this.total,
//     required this.itemsCount,
//     required this.products,
//   });
//
//   factory Order.fromMap(String id, Map<String, dynamic> map) {
//     final productsMap = map['products'] as Map<String, dynamic>? ?? {};
//     final productsList = productsMap.entries.map((e) => OrderProduct.fromMap(e.value)).toList();
//
//     return Order(
//       id: id,
//       date: map['date'] ?? 'N/A',
//       total: (map['total'] ?? 0).toDouble(),
//       itemsCount: map['itemsCount'] ?? 0,
//       products: productsList,
//     );
//   }
// }
//
// class OrderProduct {
//   final String name;
//   final double price;
//   final int quantity;
//   final String image;
//
//   OrderProduct({
//     required this.name,
//     required this.price,
//     required this.quantity,
//     required this.image,
//   });
//
//   factory OrderProduct.fromMap(Map<String, dynamic> map) {
//     return OrderProduct(
//       name: map['name'] ?? 'Unnamed',
//       price: (map['price'] ?? 0).toDouble(),
//       quantity: map['quantity'] ?? 0,
//       image: map['image'] ?? '',
//     );
//   }
// }
