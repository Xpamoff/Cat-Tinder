import 'package:flutter/foundation.dart';
import '../../domain/entities/liked_cat.dart';

class LikedCatProvider extends ChangeNotifier {
  final List<LikedCat> _likedCats = [];
  String _filterBreed = '';

  List<LikedCat> get likedCats {
    if (_filterBreed.isEmpty) return _likedCats;
    return _likedCats.where((likedCat) {
      return likedCat.cat.breed.toLowerCase().contains(
        _filterBreed.toLowerCase(),
      );
    }).toList();
  }

  String get filter => _filterBreed;

  List<LikedCat> get allLikedCats => _likedCats;

  void addLikedCat(LikedCat likedCat) {
    _likedCats.add(likedCat);
    notifyListeners();
  }

  void removeLikedCat(LikedCat likedCat) {
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
