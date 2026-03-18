import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:send_money_app/bloc/transaction/transaction_bloc.dart';
import 'package:send_money_app/bloc/transaction/transaction_event.dart';
import 'package:send_money_app/bloc/transaction/transaction_state.dart';
import 'package:send_money_app/widgets/app_bar.dart';
import 'package:intl/intl.dart'; // for formatting date

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger loading transactions automatically
    context.read<TransactionBloc>().add(LoadTransactionsEvent());
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: CustomAppBar(label: 'Transactions'),
      ),
      body: SafeArea(
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == Status.loaded) {
              if (state.transactions.isEmpty) {
                return const Center(
                  child: Text("No transactions as of this moment"),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.transactions.length,
                itemBuilder: (_, i) {
                  final tx = state.transactions[i];
                  return transactionItem(date: tx.date, amount: tx.amount);
                },
              );
            }
            if (state.status == Status.failure) {
              return const Center(
                child: Text(
                  'Failed to load transactions',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  // Transaction Item
  Widget transactionItem({required DateTime date, required double amount}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sent Money',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(date),
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          Text(
            '- PHP $amount',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF22D47A),
            ),
          ),
        ],
      ),
    );
  }
}
