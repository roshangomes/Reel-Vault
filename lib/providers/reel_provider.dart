import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/reel.dart';
import '../services/storage_service.dart';

class ReelProvider extends ChangeNotifier {
  final _storage = StorageService();
  final _uuid = const Uuid();

  List<Reel> _reels = [];
  bool isLoading = false;

  List<Reel> get reels => List.unmodifiable(_reels);

  List<Reel> byCategory(String cat, {bool includeDone = false}) =>
      _reels
          .where((r) => r.category == cat && (includeDone || !r.isDone))
          .toList();

  int countByCategory(String cat) =>
      _reels.where((r) => r.category == cat && !r.isDone).length;

  int get totalPending => _reels.where((r) => !r.isDone).length;
  int get totalDone => _reels.where((r) => r.isDone).length;

  Future<void> loadReels() async {
    isLoading = true;
    notifyListeners();
    _reels = await _storage.loadReels();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addReel({
    required String title,
    required String url,
    required String category,
    String notes = '',
  }) async {
    _reels.insert(
      0,
      Reel(
        id: _uuid.v4(),
        title: title.trim(),
        url: url.trim(),
        category: category,
        notes: notes.trim(),
        savedAt: DateTime.now(),
      ),
    );
    await _storage.saveReels(_reels);
    notifyListeners();
  }

  Future<void> updateReel(Reel updated) async {
    final i = _reels.indexWhere((r) => r.id == updated.id);
    if (i == -1) return;
    _reels[i] = updated;
    await _storage.saveReels(_reels);
    notifyListeners();
  }

  Future<void> toggleDone(String id) async {
    final i = _reels.indexWhere((r) => r.id == id);
    if (i == -1) return;
    _reels[i] = _reels[i].copyWith(isDone: !_reels[i].isDone);
    await _storage.saveReels(_reels);
    notifyListeners();
  }

  Future<void> deleteReel(String id) async {
    _reels.removeWhere((r) => r.id == id);
    await _storage.saveReels(_reels);
    notifyListeners();
  }
}
