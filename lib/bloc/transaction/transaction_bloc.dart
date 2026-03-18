import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:send_money_app/models/transaction_model.dart';
import 'package:send_money_app/repository/transaction_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repo;

  TransactionBloc(this.repo) : super(const TransactionState()) {
    // Load balance and transactions for the current user
    on<LoadBalanceEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username') ?? 'default';

      final storedBalance = prefs.getDouble('balance_$username') ?? 500.0;
      final jsonList = prefs.getStringList('transactions_$username') ?? [];
      final transactions = jsonList
          .map((e) => TransactionModel.fromJson(jsonDecode(e)))
          .toList();

      emit(state.copyWith(balance: storedBalance, transactions: transactions));
    });

    // Send Money
    on<SendMoneyEvent>((event, emit) async {
      emit(state.copyWith(status: Status.loading));

      if (event.amount <= 0 || event.amount > state.balance) {
        emit(
          state.copyWith(
            status: Status.failure,
            message: "Insufficient amount",
          ),
        );
        return;
      }

      final success = await repo.sendMoney(event.amount);

      if (success) {
        final prefs = await SharedPreferences.getInstance();
        final username = prefs.getString('username') ?? 'default';

        final newBalance = state.balance - event.amount;

        // Save new balance
        await prefs.setDouble('balance_$username', newBalance);

        // Save transaction
        final newTx = TransactionModel(
          amount: event.amount,
          date: DateTime.now(),
          description: 'Sent money',
        );
        final updatedTxs = [newTx, ...state.transactions];
        final jsonList = updatedTxs
            .map((tx) => jsonEncode(tx.toJson()))
            .toList();
        await prefs.setStringList('transactions_$username', jsonList);

        // Emit updated state
        emit(
          state.copyWith(
            status: Status.success,
            balance: newBalance,
            transactions: updatedTxs,
          ),
        );
      } else {
        emit(state.copyWith(status: Status.failure));
      }
    });

    // Load transactions only
    on<LoadTransactionsEvent>((event, emit) async {
      emit(state.copyWith(status: Status.loading));

      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username') ?? 'default';
      final jsonList = prefs.getStringList('transactions_$username') ?? [];
      final transactions = jsonList
          .map((e) => TransactionModel.fromJson(jsonDecode(e)))
          .toList();

      emit(state.copyWith(status: Status.loaded, transactions: transactions));
    });

    //Handle updating balance
    on<UpdateBalanceEvent>((event, emit) {
      emit(state.copyWith(balance: event.balance));
    });
  }
}
