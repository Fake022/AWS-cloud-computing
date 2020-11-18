import 'package:flutter/cupertino.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import 'budgets.dart';
import 'finances.dart';
import 'receipts.dart';

class User extends ChangeNotifier {
  CognitoUser _cognitoUser;
  String _token;
  Finances _finances;

  User(this._cognitoUser, this._token, this._finances);

  Finances get finances => _finances;
  List<Receipts> get receipts => _finances.receipts;
  List<Budgets> get budgets => _finances.budgets;
  get cognitoUser => _cognitoUser;
  get token => _token;

  set cognitoUser(CognitoUser value) => _cognitoUser = value;
  set token(String value) => _token = value;
  set finances(Finances value) => _finances = value;

  void setReceipts(List<Receipts> value) async {
    _finances.receipts = value;
    notifyListeners();
  }

  void setBudgets(List<Budgets> value) async {
    _finances.budgets = value;
    notifyListeners();
  }

  void addRceipt(Receipts value) async {
    _finances.receipts.add(value);
    notifyListeners();
  }

  void addBudgets(Budgets value) async {
    for (int i = 0; i < _finances.budgets.length; ++i) {
      if (_finances.budgets[i].category == value.category) {
        _finances.budgets[i] = value;
        break;
      }
    }
    notifyListeners();
  }
}
