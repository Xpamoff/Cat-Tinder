import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/cat_model.dart';
import '../../data/services/cat_service.dart';
import '../../di/injection.dart';

class CatProvider extends ChangeNotifier {
  final CatService _catService = sl<CatService>();

  final List<Cat> _cats = [];

  List<Cat> get cats => _cats;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  int _dislikeCount = 0;

  int get dislikeCount => _dislikeCount;

  Timer? _loadingTimer;

  Future<void> loadInitialCats() async {
    _isLoading = true;
    _errorMessage = null;
    _cats.clear();
    notifyListeners();

    _loadingTimer?.cancel();
    _loadingTimer = Timer(const Duration(seconds: 15), () {
      if (_isLoading) {
        _errorMessage = "Internal Error";
        _isLoading = false;
        notifyListeners();
      }
    });

    try {
      final catsList = await Future.wait([
        _catService.fetchRandomCat(),
        _catService.fetchRandomCat(),
        _catService.fetchRandomCat(),
        _catService.fetchRandomCat(),
        _catService.fetchRandomCat(),
      ]);
      _cats.addAll(catsList);
      _isLoading = false;
      _loadingTimer?.cancel();
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Error while gaining cat data";
      _loadingTimer?.cancel();
      notifyListeners();
    }
  }

  Future<void> loadNewCat() async {
    if (_errorMessage != null) return;
    try {
      final cat = await _catService.fetchRandomCat();
      _cats.add(cat);
      notifyListeners();
    } catch (e) {
      _errorMessage = "Error while gaining cat data";
      _isLoading = false;
      notifyListeners();
    }
  }

  void incrementDislikeCount() {
    _dislikeCount++;
    notifyListeners();
  }

  void retry() {
    _errorMessage = null;
    loadInitialCats();
  }
}
