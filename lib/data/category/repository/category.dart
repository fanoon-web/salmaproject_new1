import 'package:dartz/dartz.dart';

import '../../../domain/category/repository/category.dart';
import '../../../service_locator.dart';
import '../models/category.dart';
import '../source/category_firebase_service.dart';


class CategoryRepositoryImpl extends CategoryRepository {
  @override
  Future<Either> getCategories() async {
    var categories = await sl<CategoryFirebaseService>().getCategories();
    return categories.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => CategoryModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> getcategorybybrand() async {
    var categories = await sl<CategoryFirebaseService>().getcategorybybrand();
    return categories.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => CategoryModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }
}
