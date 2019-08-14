import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wang_ship/check_order.dart';
import 'package:wang_ship/report.dart';

import 'package:wang_ship/report_all.dart';

import 'package:shared_preferences/shared_preferences.dart';



class Home extends StatefulWidget {

  //var usernameVal;
  //Home({Key key, this.usernameVal}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String usernameVal;
  var username;

  int currentIndex = 0;
  List pages = [CheckOrderPage(), ReportPage(), ReportAllPage()];

  getCodeEmpShip() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("empCodeShipping");
    });
    return username;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCodeEmpShip();
  }


  @override
  Widget build(BuildContext context) {

    Widget bottomNavBar = BottomNavigationBar(
        backgroundColor: Colors.white,
        fixedColor: Colors.deepOrange,
        unselectedItemColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (int index){
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.add_to_photos),
              title: Text('ส่งสินค้า', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              title: Text('รายงานส่วนตัว', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              title: Text('รายงานทั้งหมด', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ),
        ]
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("ระบบส่งสินค้า - รหัสพนักงาน ${username}"),
        actions: <Widget>[

        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }
}
