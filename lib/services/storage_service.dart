import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reel.dart';

class StorageService {
  static const _key = 'reelvault_reels';

  Future<List<Reel>> loadReels() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Reel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveReels(List<Reel> reels) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(reels.map((r) => r.toJson()).toList()),
    );
  }
}
