import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:Bankin/models/user.dart';
import 'package:Bankin/models/receipts.dart';

import 'widgets/result.dart';

class Accounts extends StatefulWidget {
  Accounts();
  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  final http.Client _client = http.Client();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _amountController = TextEditingController();
  Map<String, String> _headers;

  @override
  void initState() {
    super.initState();
    var user = Provider.of<User>(context, listen: false);
    _headers = {
      'Authorization': user.token,
    };
  }

  @override
  void dispose() {
    _client.close();
    _nameController.dispose();
    _categoryController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> postReceipts(Receipts receipt) async {
    var response = await _client.post(
      DotEnv().env['URL_RECEIPTS'],
      headers: _headers,
      body: {
        'name': receipt.name,
        'amount': receipt.amount.toString(),
        'category': receipt.category
      },
    );
    if (response.statusCode != 200) {
      print(response.body);
    }
    var user = Provider.of<User>(context, listen: false);
    user.addRceipt(receipt);
  }

  void postIncome() {
    return;
  }

  buildCorrectList() {
    return Container(
        child: Provider.of<User>(context, listen: false).receipts != null
            ? Consumer<User>(builder: (context, user, child) {
                return ListView.builder(
                  itemCount: user.receipts.length,
                  itemBuilder: (context, int idx) {
                    return Result(user.receipts[idx]);
                  },
                );
              })
            : SpinKitFadingCube(
                color: Colors.deepPurple,
                size: 50.0,
              ));
  }

  Widget addDialog() {
    return AlertDialog(
      title: Text('Add expense'),
      content: ListView(
        shrinkWrap: true,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _categoryController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Category',
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _amountController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Amount',
            ),
          )
        ],
      ),
      actions: [
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          color: Colors.green,
          onPressed: () {
            Receipts newReceipt = Receipts(
                name: _nameController.text,
                category: _categoryController.text,
                amount: double.parse(_amountController.text));
            postReceipts(newReceipt);
            _clearControllers();
            Navigator.pop(context);
          },
          child: Text('SAVE'),
        ),
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          color: Colors.red,
          onPressed: () {
            _clearControllers();
            Navigator.pop(context);
          },
          child: Text('CANCEL'),
        ),
      ],
    );
  }

  _clearControllers() {
    _nameController.clear();
    _categoryController.clear();
    _amountController.clear();
  }

  Widget addButton(String text, Function onPressedFunc) {
    return ButtonTheme(
      minWidth: double.infinity,
      height: 50.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.blue)),
          onPressed: () {
            showDialog<void>(
                context: context, builder: (context) => addDialog());
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: Text(text, style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  int _getTotal() {
    List<Receipts> receipts =
        Provider.of<User>(context, listen: false).receipts;
    if (receipts == null) return 0;
    double res = 0;

    for (int i = 0; receipts != null && i < receipts.length; ++i) {
      res += receipts[i].amount.toDouble();
    }
    return res.truncate();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: Center(),
          centerTitle: true,
          backgroundColor: Colors.orange,
          title: Text('Account', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text('Expenses'),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text('Income'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(children: <Widget>[
              addButton('Add receipt', postReceipts),
              Text('Spent: ' + _getTotal().toString() + '\$',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Expanded(child: buildCorrectList()),
            ]),
            Column(children: <Widget>[
              addButton('Add income', postIncome),
            ]),
          ],
        ),
      ),
    );
  }
}
