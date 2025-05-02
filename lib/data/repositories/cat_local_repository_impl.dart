import 'package:drift/drift.dart';
import '../../domain/entities/liked_cat_entity.dart';
import '../local/app_database.dart';
import '../../domain/entities/cat_entity.dart';
import '../../domain/repositories/i_cat_local_repository.dart';

class CatLocalRepositoryImpl implements ICatLocalRepository {
  final AppDatabase _db;

  CatLocalRepositoryImpl(this._db);

  @override
  Future<List<CatEntity>> fetchPendingCats() async {
    final likedIds = _db.selectOnly(_db.likedCats)
      ..addColumns([_db.likedCats.id]);

    final query = _db.select(_db.cats)
      ..where((t) => t.id.isNotInQuery(likedIds));

    final rows = await query.get();
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<List<LikedCatEntity>> fetchLikedCats() async {
    final query = _db.select(_db.likedCats).join([
      innerJoin(_db.cats, _db.cats.id.equalsExp(_db.likedCats.id)),
    ]);

    final rows = await query.get();

    return rows.map((row) {
      final catData = row.readTable(_db.cats);
      final likedData = row.readTable(_db.likedCats);
      return LikedCatEntity(
        cat: catData.toEntity(),
        likedDate: likedData.likedAt,
      );
    }).toList();
  }

  Future<int> _fetchCurrentMaxId() async {
    final row =
        await _db
            .customSelect('SELECT MAX(CAST(id AS INTEGER)) AS maxId FROM cats')
            .getSingle();
    return row.data['maxId'] as int? ?? 0;
  }

  @override
  Future<List<String>> saveCats(List<CatEntity> cats) async {
    if (cats.isEmpty) return [];

    final currentMax = await _fetchCurrentMaxId();

    final companions = <CatsCompanion>[];
    final newIds = <String>[];
    for (var i = 0; i < cats.length; i++) {
      final cat = cats[i];
      final newId = (currentMax + i + 1).toString();
      newIds.add(newId);

      companions.add(
        CatsCompanion.insert(
          id: newId,
          imageUrl: cat.imageUrl,
          breed: cat.breed,
          temperament: cat.temperament,
          origin: cat.origin,
          description: cat.description,
          lifeSpan: cat.lifeSpan,
        ),
      );
    }

    await _db.batch((b) {
      b.insertAllOnConflictUpdate(_db.cats, companions);
    });

    return newIds;
  }

  @override
  Future<void> likeCat(String id) async {
    await _db
        .into(_db.likedCats)
        .insert(LikedCatsCompanion.insert(id: id, likedAt: DateTime.now()));
  }

  @override
  Future<void> removeCat(String id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.likedCats)..where((t) => t.id.equals(id))).go();
      await (_db.delete(_db.cats)..where((t) => t.id.equals(id))).go();
    });
  }

  @override
  Future<int> getLikesCount() async =>
      (await _db.select(_db.stats).get()).first.likes;

  @override
  Future<int> getDislikesCount() async =>
      (await _db.select(_db.stats).get()).first.dislikes;

  @override
  Future<void> incrementLikes() async => _db
      .update(_db.stats)
      .write(StatsCompanion(likes: Value((await getLikesCount()) + 1)));

  @override
  Future<void> incrementDislikes() async => _db
      .update(_db.stats)
      .write(StatsCompanion(dislikes: Value((await getDislikesCount()) + 1)));
}

extension on Cat {
  CatEntity toEntity() {
    return CatEntity(
      imageUrl: imageUrl,
      id: id,
      breed: breed,
      temperament: temperament,
      origin: origin,
      description: description,
      lifeSpan: lifeSpan,
    );
  }
}
