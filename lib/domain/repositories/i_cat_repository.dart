import '../entities/cat_entity.dart';

abstract class ICatRepository {
  Future<CatEntity> fetchCatImage();

  Future<CatEntity> fetchRandomCat();
}
