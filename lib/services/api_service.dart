import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:send_money_app/models/transaction_model.dart';

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<bool> sendMoney(double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'amount': amount}),
    );

    return response.statusCode == 201;
  }

  // NOTE: Only showing predefined data -> Used SharedPref for listing the actual transaction
  Future<List<TransactionModel>> getTransactions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.take(10).map((e) => TransactionModel.fromJson(e)).toList();
    }

    throw Exception('Failed to fetch transactions');
  }
}
