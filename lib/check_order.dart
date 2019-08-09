import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:barcode_scan/barcode_scan.dart';

import 'package:wang_ship/bill_model.dart';
import 'package:wang_ship/customer_sign.dart';


class CheckOrderPage extends StatefulWidget {
  @override
  _CheckOrderPageState createState() => _CheckOrderPageState();
}

class _CheckOrderPageState extends State<CheckOrderPage> {

  String barcode;

  var loading = false;
  List<Bill> _billShip = [];

  searchBill(searchVal) async{

    setState(() {
      loading = true;
    });
    _billShip.clear();

    final res = await http.get('http://wangpharma.com/API/shippingProduct.php?SearchVal=$searchVal&act=Search');

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
                _signCustomer(a);
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
                  icon: Icon(Icons.local_shipping, size: 40, color: (a.shipBillShipStatus == 1)?Colors.green:Colors.deepOrange,),
                  onPressed: (){
                    //addToOrderFast(productAll[index]);
                  }
              ),
            );
          },
        ),
      );
    }
  }

  _signCustomer(val){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomerSignPage(billOrderShip: val)));
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding (
                padding: const EdgeInsets.all(20),
                child: SizedBox (
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
                ),
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
