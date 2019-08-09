import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wang_ship/bill_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportPage extends StatefulWidget {

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  ScrollController _scrollController = new ScrollController();

  //Product product;
  List <Bill>orderBillAll = [];
  bool isLoading = true;
  int perPage = 30;
  String act = "GetShip";
  String username;


  getShipBill() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("empCodeShipping");

    final res = await http.get('http://wangpharma.com/API/shippingProduct.php?PerPage=$perPage&act=$act&username=$username&ShipStatus=2');

    if(res.statusCode == 200){

      setState(() {
        isLoading = false;

        var jsonData = json.decode(res.body);

        jsonData.forEach((orderBill) => orderBillAll.add(Bill.fromJson(orderBill)));
        perPage = perPage + 30;

        print(orderBillAll);
        print(perPage);

        return orderBillAll;

      });


    }else{
      throw Exception('Failed load Json');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShipBill();

    _scrollController.addListener((){
      //print(_scrollController.position.pixels);
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        getShipBill();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? CircularProgressIndicator()
          :ListView.builder(
        controller: _scrollController,
        itemBuilder: (context, int index){
          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(10, 1, 10, 1),
            onTap: (){
              //Navigator.push(
              //context,
              //MaterialPageRoute(builder: (context) => ReportDetailPage(receiveProducts: orderBillAll[index])));
            },
            leading: Text('${orderBillAll[index].shipBillQty} ลัง', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            title: Text('[${orderBillAll[index].shipBillCusCode}] ${orderBillAll[index].shipBillCusName}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('พิมพ์สติ๊กเกอร์ : ${orderBillAll[index].shipBillDateCreate}', style: TextStyle(color: Colors.pink),),
                Text('ที่อยู่ : ${orderBillAll[index].shipBillCusAddress}', style: TextStyle(color: Colors.teal),),
              ],
            ),
            trailing: IconButton(
                icon: Icon(Icons.local_shipping, size: 40, color: Colors.deepOrange,),
                onPressed: (){
                  //addToOrderFast(productAll[index]);
                }
            ),
          );
        },
        itemCount: orderBillAll != null ? orderBillAll.length : 0,
      ),

    );
  }
}
