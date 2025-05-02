import 'package:flutter/foundation.dart';
import '../../domain/entities/liked_cat_entity.dart';
import '../../domain/repositories/i_cat_local_repository.dart';

class LikedCatProvider extends ChangeNotifier {
  final ICatLocalRepository _localRepo;

  List<LikedCatEntity> _likedCats = [];
  String _filterBreed = '';

  LikedCatProvider({required ICatLocalRepository localRepo})
    : _localRepo = localRepo;

  Future<void> fetchLikedCats() async {
    final cats = await _localRepo.fetchLikedCats();
    _likedCats = cats;
    notifyListeners();
  }

  List<LikedCatEntity> get likedCats {
    if (_filterBreed.isEmpty) return List.unmodifiable(_likedCats);
    final lower = _filterBreed.toLowerCase();
    return _likedCats
        .where((l) => l.cat.breed.toLowerCase().contains(lower))
        .toList(growable: false);
  }

  List<LikedCatEntity> get allLikedCats => List.unmodifiable(_likedCats);

  String get filter => _filterBreed;

  void setFilter(String breed) {
    _filterBreed = breed;
    notifyListeners();
  }

  void clearFilter() {
    _filterBreed = '';
    notifyListeners();
  }

  Future<void> removeLikedCat(LikedCatEntity likedCat) async {
    await _localRepo.removeCat(likedCat.cat.id);
    _likedCats.removeWhere((l) => l.cat.id == likedCat.cat.id);
    notifyListeners();
  }
}
