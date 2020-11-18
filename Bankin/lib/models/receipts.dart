class Receipts {
  final String name;
  final String category;
  final int date;
  final double amount;

  const Receipts({this.name, this.category, this.date, this.amount});

  factory Receipts.fromJson(Map<String, dynamic> parsedJson) {
    return Receipts(
      name: parsedJson['name'] as String,
      category: parsedJson['category'] as String,
      date: parsedJson['date'] as int,
      amount: parsedJson['amount'].toDouble() as double,
    );
  }
}
