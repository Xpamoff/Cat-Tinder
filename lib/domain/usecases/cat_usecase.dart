import '../entities/cat_entity.dart';
import '../repositories/i_cat_network_repository.dart';
import '../repositories/i_cat_local_repository.dart';

class CatUseCase {
  final ICatNetworkRepository _remoteRepo;
  final ICatLocalRepository _localRepo;

  CatUseCase({
    required ICatNetworkRepository remoteRepo,
    required ICatLocalRepository localRepo,
  }) : _remoteRepo = remoteRepo,
       _localRepo = localRepo;

  Future<List<dynamic>> loadInitialCats({required bool goOnline}) async {
    List<CatEntity> pending = [];
    if (!goOnline) {
      pending = await _localRepo.fetchPendingCats();
      if (pending.length >= 5) {
        return [pending, ''];
      }
    }

    final int needed = goOnline ? 5 : (5 - pending.length);
    try {
      final newCats = <CatEntity>[];
      for (var i = 0; i < needed; i++) {
        newCats.add(await _remoteRepo.fetchRandomCat());
      }

      final newIds = await _localRepo.saveCats(newCats);

      for (var i = 0; i < newCats.length; i++) {
        newCats[i] = newCats[i].copyWith(id: newIds[i]);
      }

      final result = goOnline ? newCats : [...pending, ...newCats];
      return [result, ''];
    } catch (e) {
      final errorText = e.toString();
      return [goOnline ? <CatEntity>[] : pending, errorText];
    }
  }

  Future<CatEntity> loadNextCat() async {
    final cat = await _remoteRepo.fetchRandomCat();
    final newIds = await _localRepo.saveCats([cat]);
    return cat.copyWith(id: newIds.first);
  }

  Future<void> dislikeCat(CatEntity cat) async {
    await _localRepo.removeCat(cat.id);
    await _localRepo.incrementDislikes();
  }

  Future<void> likeCat(CatEntity cat) async {
    await _localRepo.likeCat(cat.id);
    await _localRepo.incrementLikes();
  }
}
