import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:six_jars/screens/add_funds.dart';
import 'package:six_jars/screens/subtract_fund.dart';
import 'package:six_jars/models/jar.dart';
import 'package:six_jars/models/contants.dart';
import 'package:six_jars/utils/database_helper.dart';

class ViewJars extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ViewJarsState();
  }
}

class _ViewJarsState extends State<ViewJars> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Jar> jarList;
  int count;

  @override
  Widget build(BuildContext context) {
    if (jarList == null) {
      jarList = List<Jar>();
      updateListView();
    }
    print(jarList);
    debugPrint("just abovc");

    return Scaffold(
        appBar: AppBar(
          title: Text('View Jars'),

        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          debugPrint("add income button pressed");
          navigateToAddFunds();
        },
            tooltip: "Add a influx of money",
            child: Icon(Icons.add)
        ),
        body: generateListView()

    );
  }


  ListView generateListView() {

    if (jarList.length == 0) {
      return ListView();
    }




    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading: getIcon(jarList[position]),
                title: Text("\$${jarList[position].value}"),
                subtitle: Text("${jarList[position].name}"),
                trailing: GestureDetector(
                    onTap: () {
                      navigateToSubtract(jarList[position]);
                    },
                    child: Icon(Icons.remove_circle_outline)
                ),
              ));
        }

    );
  }

  Icon getIcon(Jar jar) {
    switch (jar.name) {
      case "Necesities":
        return Icon(Icons.account_balance_wallet);
        break;
      case "Play":
        return Icon(Icons.insert_emoticon);
        break;
      case "Education":
        return Icon(Icons.bookmark);
        break;
      case "Long Term Savings":
        return Icon(Icons.monetization_on);
        break;
      case "Finacial Freedom":
        return Icon(Icons.beach_access);
        break;
      case "Giving":
        return Icon(Icons.settings_backup_restore);
        break;
    };
  }


  void navigateToSubtract(Jar jar) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) {
      return SubtractFund(jar);
    }));
    if (result == true) {
      updateListView();
    }
  }

  void navigateToAddFunds() async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) {
      return AddFunds();
    }));
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initalizeDatabase();
    dbFuture.then((database) {
      Future<List<Jar>> jarListFuture = databaseHelper.getJarList();
      jarListFuture.then((jarList) {
        setState(() {
          this.jarList = jarList;
          this.count = jarList.length;
        });
      });
    });
  }


}