import 'package:flutter/cupertino.dart';

import 'budgets.dart';
import 'receipts.dart';

class Finances {
  List<Receipts> receipts;
  List<Budgets> budgets;

  Finances({this.receipts, this.budgets});

  factory Finances.fromJson(Map<String, dynamic> parsedJson) {
    var tmpReceipts = parsedJson['receipts'] as List;
    List<Receipts> receiptsList =
        tmpReceipts.map((i) => Receipts.fromJson(i)).toList();
    var tmpBudgets = parsedJson['budgets'] as List;
    List<Budgets> budgetsList =
        tmpBudgets.map((i) => Budgets.fromJson(i)).toList();
    return Finances(
      receipts: receiptsList,
      budgets: budgetsList,
    );
  }
}
