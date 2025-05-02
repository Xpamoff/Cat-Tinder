import '../../domain/entities/cat_entity.dart';
import '../../domain/repositories/i_cat_network_repository.dart';
import '../../domain/services/i_connectivity_service.dart';
import '../services/cat_service.dart';

class CatNetworkRepository implements ICatNetworkRepository {
  final CatService _remoteDataSource;
  final IConnectivityService _connectivity;

  CatNetworkRepository(this._remoteDataSource, this._connectivity);

  @override
  Future<CatEntity> fetchCatImage() async {
    final isOnline = await _connectivity.checkConnection();
    if (!isOnline) {
      throw Exception('No internet connection');
    }
    final catModel = await _remoteDataSource.fetchCatImage();
    return catModel.toEntity();
  }

  @override
  Future<CatEntity> fetchRandomCat() async {
    final isOnline = await _connectivity.checkConnection();
    if (!isOnline) {
      throw Exception('No internet connection');
    }
    final catModel = await _remoteDataSource.fetchRandomCat();
    return catModel.toEntity();
  }
}
