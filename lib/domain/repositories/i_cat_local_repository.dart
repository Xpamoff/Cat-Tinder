import '../../domain/entities/cat_entity.dart';
import '../entities/liked_cat_entity.dart';

abstract class ICatLocalRepository {
  Future<List<CatEntity>> fetchPendingCats();

  Future<List<LikedCatEntity>> fetchLikedCats();

  Future<List<String>> saveCats(List<CatEntity> cats);

  Future<void> likeCat(String id);

  Future<void> removeCat(String id);

  Future<int> getLikesCount();

  Future<int> getDislikesCount();

  Future<void> incrementLikes();

  Future<void> incrementDislikes();
}
