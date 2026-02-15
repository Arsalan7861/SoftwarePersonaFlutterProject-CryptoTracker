import 'package:flutter/material.dart';
import '../models/coin.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../components/coin_tile.dart';
import '../components/error_display.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  List<Coin> _allCoins = [];
  List<Coin> _filteredCoins = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _showWatchlistOnly = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchCoins();
  }

  Future<void> _fetchCoins() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final coins = await _apiService.getCoins();
      setState(() {
        _allCoins = coins;
        _filterCoins();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            'Failed to load coins. Please check your internet connection.';
        _isLoading = false;
      });
    }
  }

  void _filterCoins() async {
    List<Coin> tempCoins = _allCoins;

    if (_showWatchlistOnly) {
      final watchlist = await _storageService.getWatchlist();
      tempCoins = tempCoins
          .where((coin) => watchlist.contains(coin.id))
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      tempCoins = tempCoins.where((coin) {
        final query = _searchQuery.toLowerCase();
        return coin.name.toLowerCase().contains(query) ||
            coin.symbol.toLowerCase().contains(query);
      }).toList();
    }

    setState(() {
      _filteredCoins = tempCoins;
    });
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _filterCoins();
  }

  void _toggleFilter(bool showWatchlist) {
    setState(() {
      _showWatchlistOnly = showWatchlist;
    });
    _filterCoins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Tracker'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search coins...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilterChip(
                  label: const Text('All Coins'),
                  selected: !_showWatchlistOnly,
                  onSelected: (selected) => _toggleFilter(false),
                ),
                const SizedBox(width: 10),
                FilterChip(
                  label: const Text('Watchlist'),
                  selected: _showWatchlistOnly,
                  onSelected: (selected) => _toggleFilter(true),
                ),
              ],
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage.isNotEmpty
                  ? ErrorDisplay(message: _errorMessage, onRetry: _fetchCoins)
                  : RefreshIndicator(
                      onRefresh: _fetchCoins,
                      child: ListView.builder(
                        itemCount: _filteredCoins.length,
                        itemBuilder: (context, index) {
                          final coin = _filteredCoins[index];
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen(coin: coin),
                                ),
                              );
                              // Refresh list when returning (in case watchlist changed)
                              _filterCoins();
                            },
                            child: CoinTile(
                              coin: coin,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
