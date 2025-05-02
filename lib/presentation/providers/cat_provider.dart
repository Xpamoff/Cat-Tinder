import 'package:flutter/material.dart';
import '../../domain/entities/cat_entity.dart';
import '../../domain/usecases/cat_usecase.dart';
import '../../domain/repositories/i_cat_local_repository.dart';

class CatProvider extends ChangeNotifier {
  final CatUseCase _useCase;
  final ICatLocalRepository _localRepo;

  CatProvider({
    required CatUseCase useCase,
    required ICatLocalRepository localRepo,
  }) : _useCase = useCase,
       _localRepo = localRepo {
    loadInitialCats();
  }

  final List<CatEntity> _cats = [];

  List<CatEntity> get cats => List.unmodifiable(_cats);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  int _likeCount = 0;

  int get likeCount => _likeCount;

  int _dislikeCount = 0;

  int get dislikeCount => _dislikeCount;

  Future<void> loadInitialCats() async {
    setLoading(true);
    notifyListeners();
    try {
      _likeCount = await _localRepo.getLikesCount();
      _dislikeCount = await _localRepo.getDislikesCount();
      notifyListeners();

      final result = await _useCase.loadInitialCats(goOnline: false);
      final catsList = result[0] as List<CatEntity>;
      final errorText = result[1] as String;

      if (catsList.isEmpty) {
        await loadAdditionalCats();
        return;
      }

      _cats
        ..clear()
        ..addAll(catsList);

      _errorMessage = errorText.isNotEmpty ? errorText : null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> loadAdditionalCats() async {
    setLoading(true);
    _cats.clear();
    notifyListeners();
    try {
      final result = await _useCase.loadInitialCats(goOnline: true);
      final newCats = result[0] as List<CatEntity>;
      final errorText = result[1] as String;

      if (errorText.isNotEmpty) {
        _errorMessage = '$errorText\nRetry in 10 seconds...';
        setLoading(true);
        notifyListeners();

        Future.delayed(Duration(seconds: 10), () {
          loadAdditionalCats();
        });
        return;
      }

      _cats.addAll(newCats);
      _errorMessage = null;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      _errorMessage = '${e.toString()}\nRetry in 10 seconds...';
      setLoading(true);
      notifyListeners();

      Future.delayed(Duration(seconds: 10), () {
        loadAdditionalCats();
      });
      return;
    }
  }

  Future<void> loadNextCat() async {
    if (_errorMessage != null) return;
    try {
      final next = await _useCase.loadNextCat();
      _cats.add(next);
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  Future<void> likeCat(int index) async {
    final cat = _cats[index];
    await _useCase.likeCat(cat);
    _likeCount++;
    notifyListeners();
  }

  Future<void> dislikeCat(int index) async {
    final cat = _cats[index];
    await _useCase.dislikeCat(cat);
    _dislikeCount++;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
