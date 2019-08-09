import 'package:flutter/material.dart';

class CheckOrderDetailPage extends StatefulWidget {

  var billOrderShipVal;
  CheckOrderDetailPage({Key key, this.billOrderShipVal}) : super(key: key);

  @override
  _CheckOrderDetailPageState createState() => _CheckOrderDetailPageState();
}

class _CheckOrderDetailPageState extends State<CheckOrderDetailPage> {
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
            Text('ร้าน: ${widget.billOrderShipVal.shipBillCusName}'),
            Text('รหัสรายการCom'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${widget.billOrderShipVal.shipBillCodeCom1}'),
                Text('${widget.billOrderShipVal.shipBillCodeCom2}'),
                Text('${widget.billOrderShipVal.shipBillCodeCom3}'),
              ],
            ),
            Text('รหัสรายการPart'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${widget.billOrderShipVal.shipBillCode1}'),
                Text('${widget.billOrderShipVal.shipBillCode2}'),
                Text('${widget.billOrderShipVal.shipBillCode3}'),
              ],
            ),
            Text('พิมพ์สติ๊กเกอร์ : ${widget.billOrderShipVal.shipBillDateCreate}'),
            Row(
              children: <Widget>[
                Text('ถ่ายรูปลัง'),
                Text('ถ่ายรูปร้าน'),
                Text('ถ่านรูปคนรับ'),
              ],
            ),
            Text('คนรับสินค้า'),

          ],
        ),
      ),
    );
  }
}

