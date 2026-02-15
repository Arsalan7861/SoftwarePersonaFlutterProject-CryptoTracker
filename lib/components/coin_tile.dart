import 'package:flutter/material.dart';
import '../models/coin.dart';

class CoinTile extends StatelessWidget {
  final Coin coin;

  const CoinTile({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
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
      child: ListTile(
        leading: Hero(
          tag: coin.id,
          child: Image.network(
            coin.image,
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
          ),
        ),
        title: Text(
          coin.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(coin.symbol.toUpperCase()),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${coin.currentPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              '${coin.priceChange24h.toStringAsFixed(2)}%',
              style: TextStyle(
                color: coin.priceChange24h >= 0 ? Colors.green : Colors.red,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
