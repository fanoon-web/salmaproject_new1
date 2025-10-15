import 'package:dartz/dartz.dart';


import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../repository/category.dart';

class GetCategoriesUseCase implements UseCase<Either,dynamic> {

  @override
  Future<Either> call({dynamic params}) async {
    return await sl<CategoryRepository>().getCategories();
  }

}