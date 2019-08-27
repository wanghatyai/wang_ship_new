import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import 'package:wang_ship/image_detail.dart';
import 'package:wang_ship/customer_sign.dart';

import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;

class CheckOrderDetailPage extends StatefulWidget {

  var billOrderShipVal;
  CheckOrderDetailPage({Key key, this.billOrderShipVal}) : super(key: key);

  @override
  _CheckOrderDetailPageState createState() => _CheckOrderDetailPageState();
}

class _CheckOrderDetailPageState extends State<CheckOrderDetailPage> {

  File imageFile1;
  File imageFile2;
  //File imageFile3;

  int typeCustomerGet;

  var currentLocation;

  var loading = false;

  @override
  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((currloc){
      setState(() {
        currentLocation = currloc;
        print('${currentLocation.latitude} --------  ${currentLocation.longitude}');
        //mapToggle = true;
        //addMarkerShip();
      });
    });
  }

  _openCamera(camPosition) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState((){
      /*if(camPosition == 1){
        imageFile1 = picture;
      }else if(camPosition == 2){
        imageFile2 = picture;
      }else{
        imageFile3 = picture;
      }*/

      if(camPosition == 1){
        imageFile1 = picture;
      }else{
        imageFile2 = picture;
      }

    });
    //Navigator.of(context).pop();
  }

  _decideImageView(camPosition){

    File imageFileC;

    /*if(camPosition == 1){
      imageFileC = imageFile1;
    }else if(camPosition == 2){
      imageFileC = imageFile2;
    }else{
      imageFileC = imageFile3;
    }*/

    if(camPosition == 1){
      imageFileC = imageFile1;
    }else{
      imageFileC = imageFile2;
    }

    if(imageFileC == null){
      return Image (
        image: AssetImage ( "assets/photo_default_2.png" ), width: 100, height: 100,
      );
    }else{
      return GestureDetector(
        onTap: () {
          print("open img.");
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImageDetailPage(imageFile: imageFileC)));
        },
        child: Image.file(imageFileC, width: 100, height: 100),
      );
    }
  }

  getTypeCustomerReceive(int e){
    setState(() {
      if(e == 1){
        typeCustomerGet = 1;
      } else if (e == 2) {
        typeCustomerGet = 2;
      } else if (e == 3) {
        typeCustomerGet = 3;
      } else if (e == 4) {
        typeCustomerGet = 4;
      }
    });
  }

  resizeImgFun(imageFile){

    setState(() {
      loading = true;
    });

    img.Image preImageFile = img.decodeImage(imageFile.readAsBytesSync());
    img.Image resizeImage = img.copyResize(preImageFile, width: 800);

    File resizeImageFile = File(imageFile.path)
      ..writeAsBytesSync(img.encodeJpg(resizeImage, quality: 80));

    return resizeImageFile;
  }

  _signCustomer(val, e) async{

    /*setState(() {
      loading = true;
    });*/

    /*img.Image preImageFile1 = img.decodeImage(imageFile1.readAsBytesSync());
    img.Image resizeImage1 = img.copyResize(preImageFile1, width: 800);

    File resizeImageFile1 = File(imageFile1.path)
      ..writeAsBytesSync(img.encodeJpg(resizeImage1, quality: 80));*/

    File resizeImageFile1 = await resizeImgFun(imageFile1);

    /*var stream1 = http.ByteStream(
        DelegatingStream.typed(resizeImageFile1.openRead()));
    var imgLength1 = await resizeImageFile1.length();
    var multipartFile1 = http.MultipartFile("runFile2", stream1, imgLength1,
        filename: path.basename("resizeImageFile1.jpg"));*/

    /*img.Image preImageFile2 = img.decodeImage(imageFile2.readAsBytesSync());
    img.Image resizeImage2 = img.copyResize(preImageFile2, width: 800);

    File resizeImageFile2 = File(imageFile2.path)
      ..writeAsBytesSync(img.encodeJpg(resizeImage2, quality: 80));*/

    File resizeImageFile2 = await resizeImgFun(imageFile2);

    /*var stream2 = http.ByteStream(
        DelegatingStream.typed(resizeImageFile2.openRead()));
    var imgLength2 = await resizeImageFile2.length();
    var multipartFile2 = http.MultipartFile("runFile2ex", stream2, imgLength2,
        filename: path.basename("resizeImageFile2.jpg"));*/

    /*img.Image preImageFile3 = img.decodeImage(imageFile3.readAsBytesSync());
    img.Image resizeImage3 = img.copyResize(preImageFile3, width: 800);
    File resizeImageFile3 = File(imageFile3.path)
      ..writeAsBytesSync(img.encodeJpg(resizeImage3, quality: 90));*/

    /*var stream3 = http.ByteStream(
        DelegatingStream.typed(resizeImageFile3.openRead()));
    var imgLength3 = await resizeImageFile3.length();
    var multipartFile3 = http.MultipartFile(
        "runFile2priceTag", stream3, imgLength3,
        filename: path.basename("resizeImageFile3.jpg"));*/

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomerSignPage(
            billOrderShip: val,
            typeCustomerGet: e,
            filePic1: resizeImageFile1,
            filePic2: resizeImageFile2,
            latitudeVal: currentLocation.latitude,
            longitudeVal: currentLocation.longitude
          //filePic3: resizeImageFile3
        ))).then((r){
          setState(() {
            loading = false;
          });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

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
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Text("รูปสินค้า", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      _decideImageView(1),
                      IconButton(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          icon: Icon(Icons.camera_alt, size: 50,),
                          onPressed: (){
                            _openCamera(1);
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                          }
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Text("รูปร้าน", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      _decideImageView(2),
                      IconButton(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          icon: Icon(Icons.camera_alt, size: 50,),
                          onPressed: (){
                            _openCamera(2);
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                          }
                      ),
                    ],
                  ),
                ),
                /*Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Text("รูปผู้รับสินค้า", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      _decideImageView(3),
                      IconButton(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          icon: Icon(Icons.camera_alt, size: 50,),
                          onPressed: (){
                            _openCamera(3);
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                          }
                      ),
                    ],
                  ),
                ),*/
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              width: double.infinity,
              color: Colors.deepOrange,
              child: Text('ผู้รับสินค้า', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RadioListTile(
                    title: Text('เจ้าของร้าน'),
                    onChanged:(int e) => getTypeCustomerReceive(e),
                    activeColor: Colors.deepOrange,
                    value: 1,
                    groupValue: typeCustomerGet,
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text('เภสัชกร'),
                    onChanged:(int e) => getTypeCustomerReceive(e),
                    activeColor: Colors.deepOrange,
                    value: 2,
                    groupValue: typeCustomerGet,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RadioListTile(
                    title: Text('ผู้จัดการ'),
                    onChanged:(int e) => getTypeCustomerReceive(e),
                    activeColor: Colors.deepOrange,
                    value: 3,
                    groupValue: typeCustomerGet,
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text('ฝากข้างร้าน'),
                    onChanged:(int e) => getTypeCustomerReceive(e),
                    activeColor: Colors.deepOrange,
                    value: 4,
                    groupValue: typeCustomerGet,
                  ),
                )
              ],
            ),
            loading ? CircularProgressIndicator()
                : Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: RaisedButton (
                  color: Colors.green,
                  onPressed: (){
                    _signCustomer(widget.billOrderShipVal, typeCustomerGet);
                  },
                  child:Text (
                    'ลายเช็น',
                    style: TextStyle (
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}