import 'package:flutter/foundation.dart';
import '../../domain/entities/liked_cat_entity.dart';

class LikedCatProvider extends ChangeNotifier {
  final List<LikedCatEntity> _likedCats = [];
  String _filterBreed = '';

  List<LikedCatEntity> get likedCats {
    if (_filterBreed.isEmpty) return _likedCats;
    return _likedCats.where((likedCat) {
      return likedCat.cat.breed.toLowerCase().contains(
        _filterBreed.toLowerCase(),
      );
    }).toList();
  }

  String get filter => _filterBreed;

  List<LikedCatEntity> get allLikedCats => _likedCats;

  void addLikedCat(LikedCatEntity likedCat) {
    _likedCats.add(likedCat);
    notifyListeners();
  }

  void removeLikedCat(LikedCatEntity likedCat) {
    _likedCats.remove(likedCat);
    notifyListeners();
  }

  void setFilter(String breed) {
    _filterBreed = breed;
    notifyListeners();
  }

  void clearFilter() {
    _filterBreed = '';
    notifyListeners();
  }
}
