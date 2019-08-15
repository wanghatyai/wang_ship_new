import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:barcode_scan/barcode_scan.dart';

import 'package:wang_ship/bill_model.dart';
import 'package:wang_ship/customer_sign.dart';

import 'package:wang_ship/check_order_detail.dart';

import 'package:shared_preferences/shared_preferences.dart';


class CheckOrderPage extends StatefulWidget {
  @override
  _CheckOrderPageState createState() => _CheckOrderPageState();
}

class _CheckOrderPageState extends State<CheckOrderPage> {

  TextEditingController barcodeProduct = TextEditingController();

  List<Bill> _search = [];

  String barcode;

  var loading = false;
  List<Bill> _billShip = [];

  String username;

  searchBill(searchVal) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("empCodeShipping");

    setState(() {
      loading = true;
    });
    _billShip.clear();

    final res = await http.get('https://wangpharma.com/API/shippingProduct.php?SearchVal=$searchVal&username=$username&act=Search');

    //print('http://wangpharma.com/API/shippingProduct.php?SearchVal=$searchVal&username=$username&act=Search');

    if(res.statusCode == 200){

      setState(() {

        var jsonData = json.decode(res.body);

        print(jsonData);

        jsonData.forEach((billShips) =>_billShip.add(Bill.fromJson(billShips)));

        print(_billShip);
        return _billShip;

      });

    }else{
      throw Exception('Failed load Json');
    }

  }

  scanBarcode() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState((){
        this.barcode = barcode;
        print(this.barcode);
        searchBill(this.barcode);
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _showAlertBarcode();
        print('Camera permission was denied');
      } else {
        print('Unknow Error $e');
      }
    } on FormatException {
      print('User returned using the "back"-button before scanning anything.');
    } catch (e) {
      print('Unknown error.');
    }
  }

  void _showAlertBarcode() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text('คุณไม่เปิดอนุญาตใช้กล้อง'),
        );
      },
    );
  }

  showToastAddFast(){
    Fluttertoast.showToast(
        msg: "เพิ่มรายการแล้ว",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3
    );
  }

  _showAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text('คุณกรอกรายละเอียดไม่ครบถ้วน'),
        );
      },
    );
  }

  _getBillOrderShipInfo(){

    if(!loading){
      return Text('....');
    }else{
      return Container(
        child: ListView.builder(
          shrinkWrap:true,
          itemCount: _billShip.length,
          itemBuilder: (context, i){
            final a = _billShip[i];
            return ListTile(
              contentPadding: EdgeInsets.fromLTRB(10, 1, 10, 1),
              onTap: (){
                getOrderBillDetail(a);
              },
              leading: Text('${a.shipBillQty} ลัง', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              title: Text('[${a.shipBillCusCode}] ${a.shipBillCusName}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('ที่อยู่ : ${a.shipBillCusAddress}', style: TextStyle(color: Colors.teal),),
                ],
              ),
              trailing: IconButton(
                  icon: Icon(Icons.local_shipping, size: 40, color: Colors.lightBlue),
                  onPressed: (){
                    getOrderBillDetail(a);
                    //addToOrderFast(productAll[index]);
                  }
              ),
            );
          },
        ),
      );
    }
  }

  /*_signCustomer(val){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomerSignPage(billOrderShip: val)));
  }*/

  getOrderBillDetail(val){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CheckOrderDetailPage(billOrderShipVal: val)));
  }

  @override
  void initState(){
    super.initState();
  }

  onSearch(String text) async{
    _search.clear();
    if(text.isEmpty){
      setState(() {});
      return;
    }

    searchBill(text);

    _billShip.forEach((f){
      if(f.shipBillCusCode.contains(text)) _search.add(f);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding (
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      //padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: IconButton(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          icon: Icon(Icons.settings_overscan, size: 50, color: Colors.red,),
                          onPressed: (){
                            scanBarcode();
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                          }
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: TextField (
                          controller: barcodeProduct,
                          onChanged: onSearch,
                          style: TextStyle (
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration (
                              labelText: 'Code ลูกค้า',
                              labelStyle: TextStyle (
                                fontSize: (15),
                              )
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
                /*child: SizedBox (
                  width: double.infinity,
                  height: 56,
                  child: RaisedButton (
                    color: Colors.green,
                    onPressed: scanBarcode,
                    child: Text (
                      'Scan',
                      style: TextStyle (
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),*/
              ),
              /*Padding (
              padding: const EdgeInsets.all(20),
              child: SizedBox (
                width: double.infinity,
                height: 56,
                child: RaisedButton (
                  color: Colors.blue,
                  onPressed: _signCustomer,
                  child: Text (
                    'Sign',
                    style: TextStyle (
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),*/
              _getBillOrderShipInfo(),
            ],
          ),
        )
    );
  }
}