import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final bool hidden;
  final VoidCallback onToggle;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.hidden,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.blueAccent],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hidden ? '******' : 'PHP ${balance.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontSize: 22),
          ),
          IconButton(
            icon: const Icon(Icons.visibility, color: Colors.white),
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }
}
