import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cat_tinder/domain/entities/cat_entity.dart';
import 'package:cat_tinder/domain/entities/liked_cat_entity.dart';
import 'package:cat_tinder/domain/repositories/i_cat_local_repository.dart';
import 'package:cat_tinder/presentation/providers/liked_cat_provider.dart';

class _MockLocalRepo extends Mock implements ICatLocalRepository {}

void main() {
  late LikedCatProvider provider;
  late _MockLocalRepo mockLocalRepo;

  final cat = CatEntity(
    id: '0',
    imageUrl: 'url.com',
    breed: 'British',
    temperament: 'gentle',
    origin: 'UK',
    description: 'desc',
    lifeSpan: '15',
  );
  final liked = LikedCatEntity(cat: cat, likedDate: DateTime.now());

  setUp(() {
    mockLocalRepo = _MockLocalRepo();
    provider = LikedCatProvider(localRepo: mockLocalRepo);
  });

  group('LikedCatProvider.fetchLikedCats', () {
    test('fills likedCats and allLikedCats from repo', () async {
      when(
        () => mockLocalRepo.fetchLikedCats(),
      ).thenAnswer((_) async => [liked]);

      await provider.fetchLikedCats();

      expect(provider.allLikedCats, [liked]);
      expect(provider.likedCats, [liked]);
    });
  });

  group('LikedCatProvider.filtering', () {
    setUp(() {
      when(
        () => mockLocalRepo.fetchLikedCats(),
      ).thenAnswer((_) async => [liked]);
    });

    test('setFilter narrows likedCats by breed', () async {
      await provider.fetchLikedCats();

      provider.setFilter('brit');
      expect(provider.filter, 'brit');
      expect(provider.likedCats, [liked]);

      provider.setFilter('persian');
      expect(provider.filter, 'persian');
      expect(provider.likedCats, isEmpty);
    });

    test('clearFilter resets filter and likedCats', () async {
      await provider.fetchLikedCats();

      provider.setFilter('bri');
      expect(provider.likedCats, [liked]);

      provider.clearFilter();
      expect(provider.filter, '');
      expect(provider.likedCats, [liked]);
    });
  });

  group('LikedCatProvider.removeLikedCat', () {
    test('calls repo.removeCat and updates allLikedCats', () async {
      when(
        () => mockLocalRepo.fetchLikedCats(),
      ).thenAnswer((_) async => [liked]);
      when(() => mockLocalRepo.removeCat(cat.id)).thenAnswer((_) async {});

      await provider.fetchLikedCats();
      expect(provider.allLikedCats, [liked]);

      await provider.removeLikedCat(liked);

      verify(() => mockLocalRepo.removeCat(cat.id)).called(1);
      expect(provider.allLikedCats, isEmpty);
    });
  });
}
