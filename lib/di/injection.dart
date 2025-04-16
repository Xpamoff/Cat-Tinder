import 'package:get_it/get_it.dart';
import '../data/services/cat_service.dart';
import '../data/repositories/cat_repository_impl.dart';
import '../domain/repositories/i_cat_repository.dart';
import '../presentation/providers/cat_provider.dart';
import '../presentation/providers/liked_cat_provider.dart';

final sl = GetIt.instance;

void setupInjection() {
  sl.registerLazySingleton<CatService>(() => CatService());
  sl.registerLazySingleton<ICatRepository>(
    () => CatRepositoryImpl(sl<CatService>()),
  );
  sl.registerFactory<CatProvider>(
    () => CatProvider(catRepository: sl<ICatRepository>()),
  );
  sl.registerFactory<LikedCatProvider>(() => LikedCatProvider());
}
