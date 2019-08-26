import 'package:flutter/material.dart';
import 'package:six_jars/screens/view_jars.dart';
import 'package:six_jars/screens/subtract_fund.dart';
import 'package:six_jars/screens/add_funds.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Six Jars",
      theme: ThemeData(primarySwatch: Colors.green),
      home: ViewJars()
    );
  }
}