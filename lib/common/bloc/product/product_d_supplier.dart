// import 'package:ecommerce/core/usecase/usecase.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../core/error/failure.dart';
// import '../../../domain/product/entities/product.dart';
// import 'products_display_state.dart';
// import 'package:dartz/dartz.dart'; // تأكد من استيراد هذا بشكل صحيح
//
// class ProductsDisplaysupplier extends Cubit<ProductsDisplayState> {
//   final UseCase<Either<Failure, List<ProductEntity>>, String> useCase;
//
//   ProductsDisplaysupplier({required this.useCase}) : super(ProductsInitialState());
//
//   // دالة لعرض المنتجات بناءً على supplierRef
//   void displayProducts({required String supplierRef}) async {
//     print("Cubit: fetching featured products for supplierRef: $supplierRef...");
//     emit(ProductsLoading());
//
//     final returnedData = await useCase.call(params: supplierRef);
//     returnedData.fold(
//           (error) {
//         emit(LoadProductsFailure());
//       },
//           (data) {
//         emit(ProductsLoaded(products: data));
//       },
//     );
//   }
//
//   // دالة لإعادة الحالة الأولية
//   void displayInitial() {
//     emit(ProductsInitialState());
//   }
//
//   // دالة لتغيير حالة المفضلة لمنتج معين
//   Future<void> toggleFavorite(ProductEntity product) async {
//     if (state is ProductsLoaded) {
//       final currentState = state as ProductsLoaded;
//       List<ProductEntity> updatedProducts = List.from(currentState.products);
//
//       // تحديث حالة المفضلة محليًا
//       int index = updatedProducts.indexWhere((p) => p.productId == product.productId);
//       if (index != -1) {
//         final oldProduct = updatedProducts[index];
//         final newProduct = oldProduct.copyWith(isFavorite: !oldProduct.isFavorite);
//         updatedProducts[index] = newProduct;
//
//         // هنا يجب تحديث المفضلة في المصدر (مثلاً قاعدة بيانات Firestore)
//         // يمكن استخدام UseCase آخر لتحديث المفضلة في المصدر (مثلاً `ToggleFavoriteUseCase`)
//
//         // ثم تصدر الحالة الجديدة
//         emit(ProductsLoaded(products: updatedProducts));
//       }
//     }
//   }
// }
