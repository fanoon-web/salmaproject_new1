// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
// import '../favorite_provider.dart';
//
//
// class ProductsPage extends StatelessWidget {
//   const ProductsPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final favoriteProvider = context.watch<FavoriteProvider>();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("المنتجات"),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.favorite, color: Colors.red),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const FavoritesPage()),
//               );
//             },
//           )
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('products').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("لا توجد منتجات"));
//           }
//
//           final products = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: products.length,
//             itemBuilder: (context, index) {
//               final doc = products[index];
//               final productId = doc.id;
//               final productName = doc['name'] ?? "Unnamed Product";
//
//               final isFav = favoriteProvider.isFavorite(productId);
//
//               return Card(
//                 margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 child: ListTile(
//                   title: Text(productName),
//                   trailing: IconButton(
//                     icon: Icon(
//                       isFav ? Icons.favorite : Icons.favorite_border,
//                       color: isFav ? Colors.red : Colors.grey,
//                     ),
//                     onPressed: () {
//                       if (isFav) {
//                         favoriteProvider.removeFavorite(productId);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("$productName تم حذفه من المفضلة")),
//                         );
//                       } else {
//                         favoriteProvider.addFavorite(productId, productName);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("$productName تمت إضافته للمفضلة")),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
