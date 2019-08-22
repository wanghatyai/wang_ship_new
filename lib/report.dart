import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wang_ship/bill_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wang_ship/report_detail.dart';

class ReportPage extends StatefulWidget {

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  ScrollController _scrollController = new ScrollController();

  //Product product;
  List <Bill>orderBillAll = [];
  List <Bill>orderBillLastShipFinis = [];
  bool isLoading = true;
  int perPage = 30;
  String act = "GetShip";
  String username;


  getShipBill() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("empCodeShipping");

    final res = await http.get('https://wangpharma.com/API/shippingProduct.php?PerPage=$perPage&act=$act&username=$username&ShipStatus=2');

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

  getShipBillLastFinis() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("empCodeShipping");

    final res = await http.get('https://wangpharma.com/API/shippingProduct.php?act=GetShipLastTimeFinis&username=$username');

    if(res.statusCode == 200){

      setState(() {
        isLoading = false;

        var jsonData = json.decode(res.body);

        jsonData.forEach((orderBill) => orderBillLastShipFinis.add(Bill.fromJson(orderBill)));

        print(orderBillLastShipFinis);
        print(orderBillLastShipFinis.isEmpty);

        return orderBillLastShipFinis;

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
    getShipBillLastFinis();

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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: Colors.purple,
                child: Center(
                  child: orderBillLastShipFinis.isEmpty ? Text('') : Text('ร้านที่ส่งล่าสุด : [${orderBillLastShipFinis[0].shipBillCusCode}] ${orderBillLastShipFinis[0].shipBillCusName}', style: TextStyle(fontSize: 16, color: Colors.white), ),
                ),
              ),
              Container(
                color: Colors.purple,
                child: Center(
                  child: orderBillLastShipFinis.isEmpty ?
                    Text('') : orderBillLastShipFinis[0].shipBillPeriod.isEmpty ?
                      Text('เวลา : ${orderBillLastShipFinis[0].shipBillDateShipFinis}', style: TextStyle(fontSize: 16, color: Colors.white)) :
                      Text('รอบที่ : ${orderBillLastShipFinis[0].shipBillPeriod.substring(10)} เวลา : ${orderBillLastShipFinis[0].shipBillDateShipFinis}', style: TextStyle(fontSize: 16, color: Colors.white), ),
                ),
              ),
              isLoading ? CircularProgressIndicator()
                :ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  controller: _scrollController,
                  itemBuilder: (context, int index){
                    return ListTile(
                      contentPadding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                      onTap: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReportDetailPage(billOrderShipVal: orderBillAll[index])));
                      },
                      leading: Text('${orderBillAll[index].shipBillQty} ลัง', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      title: Text('[${orderBillAll[index].shipBillCusCode}] ${orderBillAll[index].shipBillCusName}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('พิมพ์สติ๊กเกอร์ : ${orderBillAll[index].shipBillDateCreate}', style: TextStyle(color: Colors.pink),),
                          Text('ที่อยู่ : ${orderBillAll[index].shipBillCusAddress}', style: TextStyle(color: Colors.teal), overflow: TextOverflow.ellipsis),
                          Text('สแกนส่ง : ${orderBillAll[index].shipBillDateShipping}', style: TextStyle(color: Colors.pink),),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.local_shipping, size: 40, color: Colors.lightBlue,),
                        onPressed: (){
                        //addToOrderFast(productAll[index]);
                        }
                      ),
                    );
                  },
                  itemCount: orderBillAll != null ? orderBillAll.length : 0,
                ),
            ]),
          ),
      ]),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSize child;

  _SliverAppBarDelegate({ this.child });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return child;
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => child.preferredSize.height;

  @override
  // TODO: implement minExtent
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return false;
  }

}
