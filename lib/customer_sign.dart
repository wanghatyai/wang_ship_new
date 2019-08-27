import 'package:flutter/material.dart';
import 'dart:io';
//import 'dart:async';
import 'package:async/async.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:path/path.dart' as pathh;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

const directoryName = 'Signature';

class CustomerSignPage extends StatefulWidget {

  var billOrderShip;
  var typeCustomerGet;
  var latitudeVal;
  var longitudeVal;
  File filePic1;
  File filePic2;
  //File filePic3;

  CustomerSignPage({Key key,
    this.billOrderShip,
    this.typeCustomerGet,
    this.filePic1,
    this.filePic2,
    this.latitudeVal,
    this.longitudeVal
    //this.filePic3
  }) : super(key: key);

  @override
  _CustomerSignPageState createState() => _CustomerSignPageState();
}

class _CustomerSignPageState extends State<CustomerSignPage> {

  //var currentLocation;

  //GoogleMapController mapController;

  GlobalKey<SignatureState> signatureKey = GlobalKey();
  var image;
  String username;

  //File imageCusSign;

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  showToastAddFast(){
    Fluttertoast.showToast(
        msg: "ยืนยันรับสินค้าแล้ว",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("ลงลายมือรับสินค้า"),
        actions: <Widget>[
        ],
      ),*/
      body: Signature(key: signatureKey),
      persistentFooterButtons: <Widget>[
        FlatButton(
          child: Text('ลบ', style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold), ),
          onPressed: () {
            signatureKey.currentState.clearPoints();
          },
        ),
        Container(
          width: 230,
          child: Text("${widget.billOrderShip.shipBillCusName} : ${widget.billOrderShip.shipBillQty} ลัง",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
        ),

        FlatButton(
          child: Text('บันทึก', style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold), ),
          onPressed: () {
            // Future will resolve later
            // so setState @image here and access in #showImage
            // to avoid @null Checks
            setRenderedImage(context);
          },
        )
      ],
    );
  }

  setRenderedImage(BuildContext context) async {
    ui.Image renderedImage = await signatureKey.currentState.rendered;

    setState(() {
      image = renderedImage;
    });

    showImage(context);
  }

  /*addSignToServ(){
    var uri = Uri.parse("http://wangpharma.com/API/addShippingProduct.php");
    var request = http.MultipartRequest("POST", uri);
  }*/

  showImage(BuildContext context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("empCodeShipping");

    var uri = Uri.parse("https://wangpharma.com/API/addShippingProduct.php");
    var request = http.MultipartRequest("POST", uri);

    var pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);
    //Map<PermissionGroup, PermissionStatus> _permission = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if(!(await checkPermission())) await requestPermission();
    // Use plugin [path_provider] to export image to storage
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    print(path);
    await Directory('$path/$directoryName').create(recursive: true);
    File('$path/$directoryName/${formattedDate()}.png')
        .writeAsBytesSync(pngBytes.buffer.asInt8List());


    File imageCusSign = File('$path/$directoryName/${formattedDate()}.png')
      ..writeAsBytesSync(pngBytes.buffer.asInt8List());

    var streamS = http.ByteStream(DelegatingStream.typed(imageCusSign.openRead()));
    var imgLengthS = await imageCusSign.length();
    var multipartFileS = http.MultipartFile("cusSign", streamS, imgLengthS,
        filename: pathh.basename("cusSign.png"));

    var stream1 = http.ByteStream(
        DelegatingStream.typed(widget.filePic1.openRead()));
    var imgLength1 = await widget.filePic1.length();
    var multipartFile1 = http.MultipartFile("sBoxPic", stream1, imgLength1,
        filename: pathh.basename("resizeImageFile1.jpg"));

    var stream2 = http.ByteStream(
        DelegatingStream.typed(widget.filePic2.openRead()));
    var imgLength2 = await widget.filePic2.length();
    var multipartFile2 = http.MultipartFile("sStorePic", stream2, imgLength2,
        filename: pathh.basename("resizeImageFile2.jpg"));

    /*var stream3 = http.ByteStream(
        DelegatingStream.typed(widget.filePic3.openRead()));
    var imgLength3 = await widget.filePic3.length();
    var multipartFile3 = http.MultipartFile("sCusReceivePic", stream3, imgLength3,
        filename: pathh.basename("resizeImageFile3.jpg"));*/

    request.files.add(multipartFileS);

    request.files.add(multipartFile1);
    request.files.add(multipartFile2);
    //request.files.add(multipartFile3);

    request.fields['sIdCus'] = widget.billOrderShip.shipBillCusID;
    request.fields['sWhoShip'] = username;
    request.fields['sCusReceiveType'] = widget.typeCustomerGet.toString();
    request.fields['cusLatitude'] = widget.latitudeVal.toString();
    request.fields['cusLongitude'] = widget.longitudeVal.toString();

    print(multipartFileS.field);
    print(multipartFile1.field);
    print(request.fields);
    print(widget.latitudeVal.toString());
    print(widget.longitudeVal.toString());

    //Navigator.pushReplacementNamed(context, '/Home');

    var response = await request.send();

    if(response.statusCode == 200){
      print('OK OK');

      showToastAddFast();
      //Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, '/Home');

    }

    /*return showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Please check your device\'s Signature folder',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1.1
              ),
            ),
            content: Image.memory(Uint8List.view(pngBytes.buffer)),
          );
        }
    );*/
  }

  String formattedDate() {
    DateTime dateTime = DateTime.now();
    String dateTimeString = 'Signature_' +
        dateTime.year.toString() +
        dateTime.month.toString() +
        dateTime.day.toString() +
        dateTime.hour.toString() +
        ':' + dateTime.minute.toString() +
        ':' + dateTime.second.toString() +
        ':' + dateTime.millisecond.toString() +
        ':' + dateTime.microsecond.toString();
    return dateTimeString;
  }

  requestPermission() async {
    //bool result = await SimplePermissions.requestPermission(_permission);
    //Map<PermissionGroup, PermissionStatus> result = await PermissionHandler.requestPermissions(_permission);
    Map<PermissionGroup, PermissionStatus> result = await PermissionHandler().requestPermissions([PermissionGroup.storage]);

    return result;
  }

  checkPermission() async {

    //PermissionStatus result = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    bool result = await PermissionHandler().shouldShowRequestPermissionRationale(PermissionGroup.storage);
    //bool result = await SimplePermissions.checkPermission(_permission);
    return result;
  }

  getPermissionStatus() async {

    final result = await PermissionHandler().checkServiceStatus(PermissionGroup.storage);
    //final result = await SimplePermissions.getPermissionStatus(_permission);
    print("permission status is " + result.toString());
  }
}

class Signature extends StatefulWidget {
  Signature({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SignatureState();
  }
}

class SignatureState extends State<Signature> {
  // [SignatureState] responsible for receives drag/touch events by draw/user
  // @_points stores the path drawn which is passed to
  // [SignaturePainter]#contructor to draw canvas
  List<Offset> _points = <Offset>[];

  Future<ui.Image> get rendered {
    // [CustomPainter] has its own @canvas to pass our
    // [ui.PictureRecorder] object must be passed to [Canvas]#contructor
    // to capture the Image. This way we can pass @recorder to [Canvas]#contructor
    // using @painter[SignaturePainter] we can call [SignaturePainter]#paint
    // with the our newly created @canvas
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    SignaturePainter painter = SignaturePainter(points: _points);
    var size = context.size;
    painter.paint(canvas, size);
    return recorder.endRecording()
        .toImage(size.width.floor(), size.height.floor());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox _object = context.findRenderObject();
              Offset _locationPoints = _object.localToGlobal(details.globalPosition);
              _points = new List.from(_points)..add(_locationPoints);
            });
          },
          onPanEnd: (DragEndDetails details) {
            setState(() {
              _points.add(null);
            });
          },
          child: CustomPaint(
            painter: SignaturePainter(points: _points),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }

  // clearPoints method used to reset the canvas
  // method can be called using
  //   key.currentState.clearPoints();
  void clearPoints() {
    setState(() {
      _points.clear();
    });
  }
}


class SignaturePainter extends CustomPainter {
  // [SignaturePainter] receives points through constructor
  // @points holds the drawn path in the form (x,y) offset;
  // This class responsible for drawing only
  // It won't receive any drag/touch events by draw/user.
  List<Offset> points = <Offset>[];

  SignaturePainter({this.points});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.deepOrange
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 5.0;

    for(int i=0; i < points.length - 1; i++) {
      if(points[i] != null && points[i+1] != null) {
        canvas.drawLine(points[i], points[i+1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) {
    return oldDelegate.points != points;
  }

}