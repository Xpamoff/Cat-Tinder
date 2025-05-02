import 'package:get_it/get_it.dart';
import '../data/local/app_database.dart';
import '../domain/usecases/cat_usecase.dart';
import '../data/repositories/cat_network_repository_impl.dart';
import '../data/repositories/cat_local_repository_impl.dart';
import '../data/services/cat_service.dart';
import '../data/services/connectivity_service_impl.dart';
import '../domain/repositories/i_cat_network_repository.dart';
import '../domain/repositories/i_cat_local_repository.dart';
import '../domain/services/i_connectivity_service.dart';
import '../presentation/providers/cat_provider.dart';
import '../presentation/providers/liked_cat_provider.dart';

final sl = GetIt.instance;

void setupInjection() {
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  sl.registerLazySingleton<IConnectivityService>(
    () => ConnectivityServiceImpl(),
  );

  sl.registerLazySingleton<CatService>(() => CatService());

  sl.registerLazySingleton<ICatNetworkRepository>(
    () => CatNetworkRepository(sl<CatService>(), sl<IConnectivityService>()),
  );

  sl.registerLazySingleton<ICatLocalRepository>(
    () => CatLocalRepositoryImpl(sl<AppDatabase>()),
  );

  sl.registerFactory(
    () => CatUseCase(
      remoteRepo: sl<ICatNetworkRepository>(),
      localRepo: sl<ICatLocalRepository>(),
    ),
  );

  sl.registerFactory<CatProvider>(
    () => CatProvider(
      useCase: sl<CatUseCase>(),
      localRepo: sl<ICatLocalRepository>(),
    ),
  );

  sl.registerFactory<LikedCatProvider>(
    () => LikedCatProvider(localRepo: sl<ICatLocalRepository>()),
  );
}
