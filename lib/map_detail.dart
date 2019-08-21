import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDetailPage extends StatefulWidget {

  var billOrderShipVal;
  MapDetailPage({Key key, this.billOrderShipVal}) : super(key: key);

  @override
  _MapDetailPageState createState() => _MapDetailPageState();
}

class _MapDetailPageState extends State<MapDetailPage> {

  bool mapToggle = false;

  var currentLocation;

  GoogleMapController mapController;

  List<Marker> allMarkers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Geolocator().getCurrentPosition().then((currloc){
      if(widget.billOrderShipVal.shipBillCusLatitude == null){
        print('no data');
      }else{
        setState(() {
          //currentLocation = currloc;
          print('${widget.billOrderShipVal.shipBillCusLatitude}---------${widget.billOrderShipVal.shipBillCusLongitude}');

          mapToggle = true;
          addMarkerShip();
        });
      }

    //});
  }

  addMarkerShip(){
    allMarkers.add(
        Marker(
          markerId: MarkerId('${widget.billOrderShipVal.shipBillCusID}'),
          infoWindow: InfoWindow(
            title: "${widget.billOrderShipVal.shipBillCusName}",
          ),
          draggable: false,
          onTap: (){
            print('test marker position');
          },
          position: LatLng(
              double.parse(widget.billOrderShipVal.shipBillCusLatitude),
              double.parse(widget.billOrderShipVal.shipBillCusLongitude)
          ),
        )
    );
  }

  onMapCreated(controller){
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('ตำแหน่งที่อยู่ร้าน'),
      ),
      body: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height - 80,
                width: double.infinity,
                child: mapToggle ?
                GoogleMap(
                  onMapCreated: onMapCreated,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          double.parse(widget.billOrderShipVal.shipBillCusLatitude),
                          double.parse(widget.billOrderShipVal.shipBillCusLongitude)
                      ),
                      zoom: 18
                  ),
                  markers: Set.from(allMarkers),
                ):
                Center(
                  child: Text('loading... maps...', style: TextStyle(fontSize: 20)),
                ),
              )
            ],
          ),
        ],
      ),

    );
  }
}
