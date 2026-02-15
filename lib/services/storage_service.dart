import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _watchlistKey = 'watchlist';

  Future<List<String>> getWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_watchlistKey) ?? [];
  }

  Future<void> toggleWatchlist(String coinId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> watchlist = prefs.getStringList(_watchlistKey) ?? [];

    if (watchlist.contains(coinId)) {
      watchlist.remove(coinId);
    } else {
      watchlist.add(coinId);
    }

    await prefs.setStringList(_watchlistKey, watchlist);
  }

  Future<bool> isWatchlisted(String coinId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> watchlist = prefs.getStringList(_watchlistKey) ?? [];
    return watchlist.contains(coinId);
  }
}
