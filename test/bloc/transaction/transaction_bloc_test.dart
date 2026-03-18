import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:send_money_app/bloc/transaction/transaction_event.dart';
import 'package:send_money_app/bloc/transaction/transaction_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:send_money_app/bloc/transaction/transaction_bloc.dart';
import 'package:send_money_app/repository/transaction_repository.dart';
import 'package:send_money_app/services/api_service.dart';

// Mock API
class MockApi extends Mock implements ApiService {}

void main() {
  late MockApi api;
  late TransactionRepository repo;

  setUp(() {
    api = MockApi();
    repo = TransactionRepository(api);

    // Reset SharedPreferences before each test
    SharedPreferences.setMockInitialValues({
      'username': 'user1',
      'balance_user1': 500.0,
    });
  });

  group('TransactionBloc', () {
    blocTest<TransactionBloc, TransactionState>(
      'emits loading -> success with updated balance and transaction',
      build: () {
        when(() => api.sendMoney(100)).thenAnswer((_) async => true);
        return TransactionBloc(repo);
      },
      act: (bloc) async {
        // Load initial balance
        final prefs = await SharedPreferences.getInstance();
        final storedBalance = prefs.getDouble('balance_user1') ?? 500.0;
        bloc.add(UpdateBalanceEvent(storedBalance));

        // Send money
        bloc.add(SendMoneyEvent(100));
      },
      wait: const Duration(milliseconds: 100), // wait for async events
      expect: () => [
        // UpdateBalanceEvent emitted first
        const TransactionState(
          balance: 500.0,
          transactions: [],
          status: Status.initial,
        ),
        // SendMoneyEvent triggers loading
        const TransactionState(
          balance: 500.0,
          transactions: [],
          status: Status.loading,
        ),
        // Then success with updated balance and new transaction
        isA<TransactionState>()
            .having((s) => s.balance, 'balance', 400.0)
            .having((s) => s.transactions.length, 'transactions length', 1)
            .having((s) => s.status, 'status', Status.success),
      ],
    );

    blocTest<TransactionBloc, TransactionState>(
      'emits loading -> loaded with transactions from SharedPreferences',
      setUp: () async {
        // Mock SharedPreferences
        SharedPreferences.setMockInitialValues({
          'username': 'testuser',
          'transactions_testuser': [
            jsonEncode({
              'amount': 100,
              'date': DateTime.now().toIso8601String(),
              'description': 'Tx 1',
            }),
            jsonEncode({
              'amount': 200,
              'date': DateTime.now().toIso8601String(),
              'description': 'Tx 2',
            }),
          ],
        });
      },
      build: () => TransactionBloc(repo),
      act: (bloc) => bloc.add(LoadTransactionsEvent()),
      wait: const Duration(milliseconds: 100), // short wait for async
      expect: () => [
        // Loading state
        const TransactionState(
          balance: 500.0,
          transactions: [],
          status: Status.loading,
        ),
        // Loaded state with 2 transactions
        predicate<TransactionState>((state) {
          return state.status == Status.loaded &&
              state.transactions.length == 2 &&
              state.transactions[0].amount == 100 &&
              state.transactions[1].amount == 200 &&
              state.balance == 500.0;
        }),
      ],
    );

    blocTest<TransactionBloc, TransactionState>(
      'emits failure when sending invalid amount',
      build: () => TransactionBloc(repo),
      act: (bloc) => bloc.add(SendMoneyEvent(0)),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        // Loading
        const TransactionState(
          balance: 500.0,
          transactions: [],
          status: Status.loading,
        ),
        // Failure
        predicate<TransactionState>(
          (state) =>
              state.status == Status.failure &&
              state.balance == 500.0 &&
              state.transactions.isEmpty &&
              state.message == 'Insufficient amount',
        ),
      ],
    );
  });
}
