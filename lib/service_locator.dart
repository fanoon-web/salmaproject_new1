

import 'package:get_it/get_it.dart';

import 'data/category/repository/category.dart';
import 'data/category/source/category_firebase_service.dart';


import 'domain/category/repository/category.dart';
import 'domain/category/usecases/get_cate_by_brand.dart';
import 'domain/category/usecases/get_categories.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Services

  sl.registerSingleton<CategoryFirebaseService>(CategoryFirebaseServiceImpl());


  // Repositories

  sl.registerSingleton<CategoryRepository>(CategoryRepositoryImpl());



  // Usecases

  sl.registerSingleton<GetCategoriesUseCase>(GetCategoriesUseCase());
  sl.registerSingleton<GetCategorybybrandUseCase>(GetCategorybybrandUseCase());


}
