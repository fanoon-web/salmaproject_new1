import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutter/material.dart';
import '../../../../common/widgets/appbar/app_bar.dart';

import '../../category_products/pages/products_page.dart';

class AllCategoriesSimplePage extends StatelessWidget {
  const AllCategoriesSimplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriesRef = FirebaseFirestore.instance.collection('Categories');

    // استخدام theme
    final theme = Theme.of(context);
    final style_top_title_page = theme.textTheme.labelLarge;
    final displaySmall = theme.textTheme.displaySmall;

    return Scaffold(
      appBar: BasicAppbar(
        hideBack: false,
        title: Text('All categories', style: style_top_title_page),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: categoriesRef.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final categories = snapshot.data!.docs;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final categoryId = category.id;
              final categoryTitle = category['title'] ?? 'Category';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductsPage(categoryId: categoryId),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor == Colors.white
                        ? Colors.grey[200]   // Light
                        : Colors.grey[800],  // Dark
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: theme.scaffoldBackgroundColor == Colors.white
                            ? Colors.grey[200]
                            : Colors.grey[700],
                        backgroundImage: NetworkImage(
                          category['image'] ?? 'https://via.placeholder.com/150',
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(categoryTitle, style:

                      Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold
                          ),)
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
