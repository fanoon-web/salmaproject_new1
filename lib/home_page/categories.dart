import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../category_products/pages/products_page.dart';
import '../all_categories/pages/all_categories.dart';
import '../common/helper/navigator/app_navigator.dart';
import '../core/configs/theme/app_colors.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _seeAll(context),
        const SizedBox(height: 20),
        _categoriesList(context),
      ],
    );
  }

  Widget _seeAll(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const  Text(
            "Categories",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
              fontSize: 18,
            ),
          ),
          GestureDetector(
            onTap: () {
              AppNavigator.push(context, const AllCategoriesSimplePage());
            },
            child:   Text(
              "See all",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
                fontSize: 14,
                color: AppColors.adminPrimary,
              ),

            ),
          ),
        ],
      ),
    );
  }

  Widget _categoriesList(BuildContext context) {
    final categoriesRef = FirebaseFirestore.instance.collection('Categories');

    return SizedBox(
      height: 100,
      child: FutureBuilder<QuerySnapshot>(
        future: categoriesRef.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = snapshot.data!.docs;

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 30),
            itemBuilder: (context, index) {
              final category = categories[index];
              final categoryId = category.id;
              final categoryTitle = category['title'] ?? 'Category';
              final categoryImage = category['image'] ??
                  'https://via.placeholder.com/150'; // رابط مباشر

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductsPage(categoryId: categoryId),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black12,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(categoryImage),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      categoryTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
