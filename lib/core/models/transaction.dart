class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.status,
  });

  final String id;
  final String title;
  final double amount;
  final String date;
  final String type;
  final String status;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'date': date,
        'type': type,
        'status': status,
      };

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: json['date'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
    );
  }
}
