import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../models/receipts.dart';

class Result extends StatelessWidget {
  final Receipts _receipt;
  final Map<String, IconData> _catogoryMap = {
    'Shopping': FontAwesomeIcons.shoppingCart,
    'Food': FontAwesomeIcons.utensils,
    'Grocery': FontAwesomeIcons.carrot,
    'Bills': FontAwesomeIcons.fileInvoiceDollar,
    'Health': FontAwesomeIcons.cross,
    'Entertainment': FontAwesomeIcons.gamepad,
    'Transport': FontAwesomeIcons.car,
  };

  Result(this._receipt);

  categoryIcon() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 7.0),
      child:
          Icon(_catogoryMap[_receipt.category], size: 25, color: Colors.blue),
    );
  }

  String getDate() {
    final f = new DateFormat('yyyy-MM-dd hh:mm');
    return f.format(DateTime.fromMillisecondsSinceEpoch(_receipt.date == null
        ? DateTime.now().millisecondsSinceEpoch
        : _receipt.date));
  }

  Flexible buildCard(context) {
    return Flexible(
      flex: 7,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: Colors.grey.withAlpha(50)),
          child: ListTile(
            leading: categoryIcon(),
            title: Text(_receipt.name,
                style: TextStyle(
                    color: Colors.blueGrey, fontWeight: FontWeight.bold)),
            subtitle: Text(getDate()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(_receipt.amount.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Icon(FontAwesomeIcons.dollarSign, color: Colors.red)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 10),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                buildCard(context),
              ],
            ),
          ],
        ));
  }
}
