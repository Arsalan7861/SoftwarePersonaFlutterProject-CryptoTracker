import 'package:flutter/material.dart';
import '../models/coin.dart';
import '../services/storage_service.dart';

class DetailScreen extends StatefulWidget {
  final Coin coin;

  const DetailScreen({super.key, required this.coin});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final StorageService _storageService = StorageService();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFav = await _storageService.isWatchlisted(widget.coin.id);
    setState(() {
      _isFavorite = isFav;
    });
  }

  Future<void> _toggleFavorite() async {
    await _storageService.toggleWatchlist(widget.coin.id);
    _checkFavoriteStatus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? 'Removed from Watchlist' : 'Added to Watchlist',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = widget.coin.priceChange24h >= 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin.name),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star : Icons.star_border,
              color: _isFavorite ? Colors.amber : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Price Card
              _buildCard(
                child: Column(
                  children: [
                    Hero(
                      tag: widget.coin.id,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          widget.coin.image,
                          height: 80,
                          width: 80,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.currency_bitcoin, size: 80),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.coin.symbol.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${widget.coin.currentPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isPositive
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositive
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: isPositive ? Colors.green : Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${isPositive ? '+' : ''}${widget.coin.priceChange24h.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: 16,
                              color: isPositive ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '24h Change',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Market Stats Card
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.bar_chart_rounded,
                          color: Colors.grey[700],
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Market Stats',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildStatRow('Symbol', widget.coin.symbol.toUpperCase()),
                    _buildStatRow('Coin ID', widget.coin.id),
                    _buildStatRow(
                      'Current Price',
                      '\$${widget.coin.currentPrice.toStringAsFixed(2)}',
                    ),
                    _buildStatRow(
                      '24h Change',
                      '${isPositive ? '+' : ''}${widget.coin.priceChange24h.toStringAsFixed(2)}%',
                      valueColor: isPositive ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Watchlist Action Card
              _buildCard(
                child: InkWell(
                  onTap: _toggleFavorite,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _isFavorite
                                ? Colors.amber.shade50
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _isFavorite ? Icons.star : Icons.star_border,
                            color: _isFavorite ? Colors.amber : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isFavorite
                                    ? 'In Your Watchlist'
                                    : 'Add to Watchlist',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _isFavorite
                                    ? 'Tap to remove from watchlist'
                                    : 'Track this coin\'s performance',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.grey[400]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildStatRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15, color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
