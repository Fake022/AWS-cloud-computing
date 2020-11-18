import 'package:flutter/material.dart';

import 'package:flip_card/flip_card.dart';

import 'package:Bankin/models/budgets.dart';

class Result extends StatelessWidget {
  final Budgets _budgets;
  final Map<String, Color> _colorMap = {
    'family': Colors.blue,
    'vacation': Colors.pink,
    'saving': Colors.indigo,
  };

  Result(this._budgets);

  Card _buildCard(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 20.0, bottom: 0.0),
      color: Color(0x00000000),
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        speed: 500,
        onFlipDone: (status) {
          print(status);
        },
        front: Container(
          decoration: BoxDecoration(
            color: _colorMap[_budgets.category],
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_budgets.category,
                  style: TextStyle(color: Colors.white, fontSize: 40)),
            ],
          ),
        ),
        back: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('\$' + _budgets.amount.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 40)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: _buildCard(context),
    );
  }
}
