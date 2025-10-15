// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../core/configs/theme/app_theme.dart';
//
//
// import '../../../common/bloc/product/products_display_cubit.dart';
// import '../../../common/bloc/product/products_display_state.dart';
//
// class ProductsGridPage extends StatelessWidget {
//   final String categoryId;
//   final String? selectedBrandId;
//   final String? selectedCondition;
//   final String searchQuery;
//
//   const ProductsGridPage({
//     super.key,
//     required this.categoryId,
//     this.selectedBrandId,
//     this.selectedCondition,
//     this.searchQuery = '',
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final textTheme = theme.textTheme;
//
//     return BlocBuilder<ProductsDisplayCubit, ProductsDisplayState>(
//       builder: (context, state) {
//         if (state is ProductsLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (state is ProductsLoaded) {
//           final filteredProducts = state.products.where((product) {
//             final matchBrand =
//                 selectedBrandId == null || product.brandId == selectedBrandId;
//             final matchSearch = searchQuery.isEmpty ||
//                 product.title.toLowerCase().contains(searchQuery);
//             final matchCategory = product.categoryId == categoryId;
//             final matchCondition = selectedCondition == null ||
//                 product.condition == selectedCondition;
//
//             return matchBrand &&
//                 matchSearch &&
//                 matchCategory &&
//                 matchCondition;
//           }).toList();
//
//           if (filteredProducts.isEmpty) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 200),
//                 child: Text(
//                   "No Products ",
//                   style: textTheme.headlineMedium,
//                 ),
//               ),
//             );
//           }
//
//           // Responsive Grid
//           final screenWidth = MediaQuery.of(context).size.width;
//           int crossAxisCount = 2;
//           double childAspectRatio = 0.5;
//
//           if (screenWidth > 1200) {
//             crossAxisCount = 5;
//             childAspectRatio = 0.75;
//           } else if (screenWidth > 800) {
//             crossAxisCount = 4;
//             childAspectRatio = 0.75;
//           } else if (screenWidth < 350) {
//             crossAxisCount = 1;
//             childAspectRatio = 0.8;
//           }
//
//           return GridView.builder(
//             padding: const EdgeInsets.all(16),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: crossAxisCount,
//               childAspectRatio: childAspectRatio,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//             ),
//             itemCount: filteredProducts.length,
//             itemBuilder: (context, index) {
//               final product = filteredProducts[index];
//               return ProductCard(productEntity: product);
//             },
//           );
//         }
//
//         return const SizedBox.shrink();
//       },
//     );
//   }
// }
