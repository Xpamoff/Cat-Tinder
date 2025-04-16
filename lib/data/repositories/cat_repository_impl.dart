import '../../data/services/cat_service.dart';
import '../../domain/entities/cat_entity.dart';
import '../../domain/repositories/i_cat_repository.dart';

class CatRepositoryImpl implements ICatRepository {
  final CatService remoteDataSource;

  CatRepositoryImpl(this.remoteDataSource);

  @override
  Future<CatEntity> fetchCatImage() async {
    final catModel = await remoteDataSource.fetchCatImage();
    return catModel.toEntity();
  }

  @override
  Future<CatEntity> fetchRandomCat() async {
    final catModel = await remoteDataSource.fetchRandomCat();
    return catModel.toEntity();
  }
}
