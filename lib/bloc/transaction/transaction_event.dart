import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendMoneyEvent extends TransactionEvent {
  final double amount;
  SendMoneyEvent(this.amount);
}

class LoadTransactionsEvent extends TransactionEvent {}

class LoadBalanceEvent extends TransactionEvent {}

class UpdateBalanceEvent extends TransactionEvent {
  final double balance;
  UpdateBalanceEvent(this.balance);
}
