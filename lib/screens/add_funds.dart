import 'package:flutter/material.dart';
import 'package:six_jars/utils/database_helper.dart';
import 'package:six_jars/models/jar.dart';
import 'package:six_jars/models/contants.dart';
import 'package:six_jars/utils/utils.dart';

class AddFunds extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddFundsState();
  }
}

class _AddFundsState extends State<AddFunds> {

  var _formKey = GlobalKey<FormState>();

  DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {moveToLastScreen();},
      child: Scaffold(
        appBar: AppBar(title: Text("Add Funds")),
        body: Form(
          key: _formKey,
        child: ListView(
          children: <Widget>[
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
                    // ignore: missing_return
                    }

                   // if (double.parse(value) > double.parse())
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.0))
                      ),
                      labelText: 'Amount',
                      hintText: 'The amount to add i.e. 9.99'
                  ),
                )
            ),
            Padding(
              padding: EdgeInsets.all(9.0),
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  debugPrint("button pressed");
                  if (_formKey.currentState.validate()) {
debugPrint("[assed valida");
                    _distributeFunds();
                  }
                },
                child: Text("Add Funds"),
              )
            )
          ],
        ))
    ));
  }



  void moveToLastScreen () {
    Navigator.pop(context, true);
  }

  void _distributeFunds() async {
   List<Jar> jars = await databaseHelper.getJarList();
   jars.forEach((nextJar) async {
     debugPrint("Setting ${nextJar.name} to ${double.parse(nextJar.value) + (double.parse(nextJar.percent) * double.parse(amountController.text))}");
       nextJar.value = "${double.parse(nextJar.value) + (double.parse(nextJar.percent) * double.parse(amountController.text))}";
       await databaseHelper.updateJar(nextJar);
   });
   moveToLastScreen();
  }

}