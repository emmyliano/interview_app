class Account {
  const Account({
    required this.id,
    required this.name,
    required this.currency,
    required this.balance,
  });

  final String id;
  final String name;
  final String currency;
  final double balance;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'currency': currency,
        'balance': balance,
      };

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String,
      name: json['name'] as String,
      currency: json['currency'] as String,
      balance: (json['balance'] as num).toDouble(),
    );
  }
}
