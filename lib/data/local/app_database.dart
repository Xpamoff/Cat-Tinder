import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Cats extends Table {
  TextColumn get id => text()();

  TextColumn get imageUrl => text()();

  TextColumn get breed => text()();

  TextColumn get temperament => text()();

  TextColumn get origin => text()();

  TextColumn get description => text()();

  TextColumn get lifeSpan => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class LikedCats extends Table {
  TextColumn get id => text()();

  DateTimeColumn get likedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Stats extends Table {
  IntColumn get statId => integer().withDefault(const Constant(0))();

  IntColumn get likes => integer().withDefault(const Constant(0))();

  IntColumn get dislikes => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {statId};
}

@DriftDatabase(tables: [Cats, LikedCats, Stats])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();

      await into(
        stats,
      ).insert(StatsCompanion(likes: const Value(0), dislikes: const Value(0)));
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'cats.sqlite'));
    return NativeDatabase(file);
  });
}
