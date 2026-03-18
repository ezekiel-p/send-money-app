import 'package:send_money_app/models/transaction_model.dart';
import 'package:send_money_app/services/api_service.dart';

class TransactionRepository {
  final ApiService api;

  TransactionRepository(this.api);

  Future<bool> sendMoney(double amount) {
    return api.sendMoney(amount);
  }

  Future<List<TransactionModel>> getTransactions() {
    return api.getTransactions();
  }
}
