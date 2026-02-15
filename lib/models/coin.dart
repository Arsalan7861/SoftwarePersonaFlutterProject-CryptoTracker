class Coin {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double priceChange24h;

  Coin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChange24h,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      // Handle int/double types for prices safely
      currentPrice: (json['current_price'] as num).toDouble(),
      priceChange24h: (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
