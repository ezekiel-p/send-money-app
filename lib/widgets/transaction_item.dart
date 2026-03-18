import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:send_money_app/models/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel tx;

  const TransactionItem(this.tx, {super.key});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMd().add_jm().format(tx.date);

    return ListTile(title: Text('PHP ${tx.amount}'), subtitle: Text(date));
  }
}
