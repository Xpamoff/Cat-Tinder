import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cat_tinder/domain/entities/cat_entity.dart';
import 'package:cat_tinder/domain/usecases/cat_usecase.dart';
import 'package:cat_tinder/domain/repositories/i_cat_local_repository.dart';
import 'package:cat_tinder/presentation/providers/cat_provider.dart';

class FakeCatEntity extends Fake implements CatEntity {}

class _MockUseCase extends Mock implements CatUseCase {}

class _MockLocalRepo extends Mock implements ICatLocalRepository {}

void main() {
  late CatProvider provider;
  late _MockUseCase mockUseCase;
  late _MockLocalRepo mockLocalRepo;

  final testCat = CatEntity(
    id: '0',
    imageUrl: 'url.com',
    breed: 'British',
    temperament: 'gentle',
    origin: 'UK',
    description: 'desc',
    lifeSpan: '15',
  );

  setUpAll(() {
    registerFallbackValue(FakeCatEntity());
  });

  setUp(() {
    mockUseCase = _MockUseCase();
    mockLocalRepo = _MockLocalRepo();

    when(() => mockLocalRepo.getLikesCount()).thenAnswer((_) async => 0);
    when(() => mockLocalRepo.getDislikesCount()).thenAnswer((_) async => 0);

    when(() => mockUseCase.loadInitialCats(goOnline: false)).thenAnswer(
      (_) async => [
        [testCat],
        '',
      ],
    );

    when(() => mockUseCase.loadInitialCats(goOnline: true)).thenAnswer(
      (_) async => [
        [testCat],
        '',
      ],
    );

    when(() => mockUseCase.likeCat(any())).thenAnswer((_) async {});
    when(() => mockUseCase.dislikeCat(any())).thenAnswer((_) async {});

    provider = CatProvider(useCase: mockUseCase, localRepo: mockLocalRepo);
  });

  group('CatProvider initial load', () {
    test('constructor fills cats from useCase', () async {
      await Future.microtask(() {});
      expect(provider.cats, [testCat]);
      expect(provider.likeCount, 0);
      expect(provider.dislikeCount, 0);
      expect(provider.errorMessage, isNull);
      expect(provider.isLoading, isFalse);
    });
  });

  group('CatProvider.likeCat', () {
    test('increments likeCount and calls useCase.likeCat', () async {
      await provider.loadInitialCats();
      await provider.likeCat(0);

      expect(provider.likeCount, 1);
      verify(() => mockUseCase.likeCat(testCat)).called(1);
    });
  });

  group('CatProvider.dislikeCat', () {
    test('increments dislikeCount and calls useCase.dislikeCat', () async {
      await provider.loadInitialCats();
      await provider.dislikeCat(0);

      expect(provider.dislikeCount, 1);
      verify(() => mockUseCase.dislikeCat(testCat)).called(1);
    });
  });

  group('CatProvider.loadInitialCats with empty offline list', () {
    test(
      'falls back to loadAdditionalCats and fills cats from online',
      () async {
        when(
          () => mockUseCase.loadInitialCats(goOnline: false),
        ).thenAnswer((_) async => [<CatEntity>[], '']);

        final onlineCat = CatEntity(
          id: '1',
          imageUrl: 'url.ru',
          breed: 'Russian',
          temperament: 'gentle',
          origin: 'Russia',
          description: 'desc',
          lifeSpan: '20',
        );
        when(() => mockUseCase.loadInitialCats(goOnline: true)).thenAnswer(
          (_) async => [
            [onlineCat],
            '',
          ],
        );

        await provider.loadInitialCats();

        expect(provider.cats, [onlineCat]);
        expect(provider.errorMessage, isNull);
        expect(provider.isLoading, isFalse);

        verifyInOrder([
          () => mockUseCase.loadInitialCats(goOnline: false),
          () => mockUseCase.loadInitialCats(goOnline: true),
        ]);
      },
    );
  });
}
