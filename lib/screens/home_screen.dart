import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:send_money_app/bloc/transaction/transaction_bloc.dart';
import 'package:send_money_app/bloc/transaction/transaction_event.dart';
import 'package:send_money_app/bloc/transaction/transaction_state.dart';
import 'package:send_money_app/widgets/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'send_screen.dart';
import 'transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hidden = false;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsernameAndBalance();
  }

  Future<void> _loadUsernameAndBalance() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username') ?? '';
    setState(() {
      _username = storedUsername;
    });

    // Load balance for this user
    final balance = prefs.getDouble('balance_$storedUsername') ?? 500.0;

    // Update Bloc state
    if (mounted) {
      context.read<TransactionBloc>().add(UpdateBalanceEvent(balance));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: CustomAppBar(label: 'Welcome, $_username'),
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _walletCard(amount: state.balance.toStringAsFixed(2)),
                const SizedBox(height: 40),
                _buttons(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Wallet Card
  Widget _walletCard({required String amount}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Wallet Balance',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                _hidden ? '******' : 'PHP $amount',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              _hidden ? Icons.visibility_off : Icons.visibility,
              color: Colors.black,
              size: 28,
            ),
            onPressed: () => setState(() => _hidden = !_hidden),
          ),
        ],
      ),
    );
  }

  // Send Money and Transaction History Button
  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22D47A),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SendScreen()),
            ),
            child: const Text(
              'Send Money',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TransactionScreen()),
            ),
            child: const Text(
              'Transactions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
