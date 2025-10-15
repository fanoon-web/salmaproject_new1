// import 'package:ecommerce/core/usecase/usecase.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../domain/product/entities/product.dart';
// import 'products_display_state.dart';
//
// class ProductsDisplayCubit extends Cubit<ProductsDisplayState> {
//   final UseCase useCase;
//   ProductsDisplayCubit({required this.useCase}) : super(ProductsInitialState());
//
//   void displayProducts({dynamic params}) async {
//     print("Cubit: fetching favorite products...");
//     emit(ProductsLoading());
//     var returnedData = await useCase.call(params: params);
//     returnedData.fold(
//             (error) {
//           emit(LoadProductsFailure());
//         },
//             (data) {
//           emit(ProductsLoaded(products: data));
//         }
//     );
//   }
//
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
//         // هنا لازم تحدث المفضلة في المصدر (مثلاً قاعدة بيانات Firestore)
//         // لو تستخدم UseCase خاص بتحديث المفضلة، استدعِه هنا
//         // await useCaseToggleFavorite.call(params: product.productId);
//
//         // ثم تصدر الحالة الجديدة
//         emit(ProductsLoaded(products: updatedProducts));
//       }
//     }
//   }
// }
