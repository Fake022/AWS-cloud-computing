import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flip_card/flip_card.dart';

import 'package:Bankin/models/user.dart';

class Budget extends StatefulWidget {
  Budget();
  @override
  _BudgetState createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  final http.Client _client = http.Client();

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  _renderContent(
      BuildContext context, Color color, String category, double total) {
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
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(category,
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
              Text('\$' + total.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 40)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var budgets = Provider.of<User>(context, listen: false).budgets;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: Container(),
        title: Text("Budget"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            child: _renderContent(
                context, Colors.blue, 'Family', budgets[0].amount),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            child: _renderContent(
                context, Colors.pink, 'Vacation', budgets[1].amount),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            child: _renderContent(
                context, Colors.indigo, 'Saving', budgets[2].amount),
          ),
        ],
      ),
    );
  }
}
