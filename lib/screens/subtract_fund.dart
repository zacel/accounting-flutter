import 'package:flutter/material.dart';
import 'package:six_jars/models/jar.dart';
import 'package:six_jars/utils/database_helper.dart';
import 'package:six_jars/utils/utils.dart';

class SubtractFund extends StatefulWidget {
  final Jar jar;

  SubtractFund(this.jar);

  @override
  State<StatefulWidget> createState() {
    return _SubtractFundState(this.jar);
  }
}

class _SubtractFundState extends State<SubtractFund> {

  Jar jar;

  _SubtractFundState(this.jar);

  DatabaseHelper databaseHelper = DatabaseHelper();

  TextEditingController amountController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()
    {
      moveToLastScreen();
    },
    child: Form(
    key: _formKey,
    child: Scaffold(
    appBar: AppBar(title: Text("${jar.name}")),
    body: ListView(children: <Widget>[
    Padding(
    padding: EdgeInsets.all(9.0),
    child: Text("\$${jar.value}", textAlign: TextAlign.center, style: TextStyle(
    fontSize: 50.0,

    )),
    ),
    Padding(
    padding: EdgeInsets.all(9.0),
    child: TextFormField(
    controller: amountController,
    validator: (String value) {
        if (value.isEmpty) {
          return "Please enter an amount";
    }

        var parsed = tryParse(value);
        if (parsed == null) {
          return "A valid number like 1 or 1.99";
    }
    },
    decoration: InputDecoration(
    labelText: "Amount",
    hintText: "amount to withdraw i.e. 2.99",
    border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)))),
    keyboardType: TextInputType.number,

    ),
    ),
    Padding(
    padding: EdgeInsets.all(9.0),
    child: RaisedButton(
    onPressed: () {
    debugPrint("button pressed");
    if (_formKey.currentState.validate()) {

    deductAmount();
    }
    },
    color: Theme.of(context).primaryColor,
    textColor: Colors.white,
    child: Text("Deduct")))
    ]))
    ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void deductAmount() {
    jar.value =
    "${double.parse(jar.value) - double.parse(amountController.text)}";
    _save();
  }

  void _save() async {
    moveToLastScreen();
    int result;
    result = await databaseHelper.updateJar(jar);
    if (result != 0) {
      _showAlertDialog('Status', 'Jar Updated');
    } else {
      _showAlertDialog('Status', 'Error Updating Jar');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
        title: Text(title),
        content: Text(message)
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }
}
