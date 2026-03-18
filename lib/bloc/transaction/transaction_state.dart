import 'package:equatable/equatable.dart';
import 'package:send_money_app/models/transaction_model.dart';

enum Status { initial, loading, success, failure, loaded, loggedOut }

class TransactionState extends Equatable {
  final double balance;
  final List<TransactionModel> transactions;
  final Status status;
  final String message;

  const TransactionState({
    this.balance = 500,
    this.transactions = const [],
    this.status = Status.initial,
    this.message = "",
  });

  TransactionState copyWith({
    double? balance,
    List<TransactionModel>? transactions,
    Status? status,
    String? message,
  }) {
    return TransactionState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [balance, transactions, status, message];
}
