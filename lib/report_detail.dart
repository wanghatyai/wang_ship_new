import 'package:flutter/material.dart';
import 'dart:io';
import 'package:wang_ship/map_detail.dart';

class ReportDetailPage extends StatefulWidget {

  var billOrderShipVal;
  ReportDetailPage({Key key, this.billOrderShipVal}) : super(key: key);

  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {

  List shipType = ['_','บริการส่ง','ฝากรถ','รับเองที่คลัง','รับเองที่หจก','พร้อมรถ'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("รายละเอียดรายการ"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text('ร้าน: ${widget.billOrderShipVal.shipBillCusName}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Text('ที่อยู่: ${widget.billOrderShipVal.shipBillCusAddress}', style: TextStyle(fontSize: 16)),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(icon: Icon(Icons.room, color: Colors.red, size: 40,),onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapDetailPage(billOrderShipVal: widget.billOrderShipVal)));
                  }),
                ),
              ],
            ),
            Text('เวลาเปิดร้าน: ${widget.billOrderShipVal.shipBillCusOpenStoreTime}', style: TextStyle(fontSize: 16)),
            Container(
              padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
              width: double.infinity,
              color: Colors.blueGrey,
              child: Text('รหัส Com', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${widget.billOrderShipVal.shipBillCodeCom1}', style: TextStyle(fontSize: 16,)),
                Text('${widget.billOrderShipVal.shipBillCodeCom2}', style: TextStyle(fontSize: 16,)),
                Text('${widget.billOrderShipVal.shipBillCodeCom3}', style: TextStyle(fontSize: 16,)),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
              width: double.infinity,
              color: Colors.blueGrey,
              child: Text('รหัส Part', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${widget.billOrderShipVal.shipBillCode1}', style: TextStyle(fontSize: 16,)),
                Text('${widget.billOrderShipVal.shipBillCode2}', style: TextStyle(fontSize: 16,)),
                Text('${widget.billOrderShipVal.shipBillCode3}', style: TextStyle(fontSize: 16,)),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
              width: double.infinity,
              color: Colors.blue,
              child: Text('พิมพ์สติ๊กเกอร์ : ${widget.billOrderShipVal.shipBillDateCreate}', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
              width: double.infinity,
              color: Colors.purple,
              child: Text('รูปแบบการส่ง : ${shipType[int.parse(widget.billOrderShipVal.shipBillShipType)]}', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }
}
