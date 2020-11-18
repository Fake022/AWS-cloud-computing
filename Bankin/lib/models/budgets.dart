class Budgets {
  final double amount;
  final String category;

  const Budgets({this.amount, this.category});

  factory Budgets.fromJson(Map<String, dynamic> parsedJson) {
    return Budgets(
      amount: parsedJson['amount'].toDouble() as double,
      category: parsedJson['category'] as String,
    );
  }
}
