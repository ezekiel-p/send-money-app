class TransactionModel {
  final double amount;
  final DateTime date;
  final String description;

  TransactionModel({
    required this.amount,
    required this.date,
    required this.description,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'date': date.toIso8601String(),
    'description': description,
  };
}
