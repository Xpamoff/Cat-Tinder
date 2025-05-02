import '../entities/cat_entity.dart';

abstract class ICatNetworkRepository {
  Future<CatEntity> fetchCatImage();

  Future<CatEntity> fetchRandomCat();
}
