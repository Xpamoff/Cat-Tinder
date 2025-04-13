import 'package:get_it/get_it.dart';
import '../data/services/cat_service.dart';
import '../presentation/providers/liked_cat_provider.dart';
import '../presentation/providers/cat_provider.dart';

final sl = GetIt.instance;

void setupInjection() {
  sl.registerLazySingleton<CatService>(() => CatService());
  sl.registerFactory<LikedCatProvider>(() => LikedCatProvider());
  sl.registerFactory<CatProvider>(() => CatProvider());
}
