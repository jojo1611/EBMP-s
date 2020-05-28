import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:example/app_State.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_webservice/places.dart';


class HomeDriver extends StatefulWidget {
  @override
  _HomeDriverState createState() => _HomeDriverState();
}

class _HomeDriverState extends State<HomeDriver> {

  List<String> _locations = ['Hostel A', 'Hostel B', 'Hostel C', 'Hostel D'];
  List<String> _locationsDes = ['Hostel A', 'Hostel B', 'Hostel C', 'Hostel D'];

  String selectedLocation;
  String selectedDestination ;
  GoogleMapController mapController ;

  Set<Marker> marker = {} ;
  Set<Marker> markerD = {} ;
  Set<Polyline> polyline = {};
  LatLng _origin;
  LatLng _destination;

  void MapCreated(GoogleMapController controller){
    setState(() {
      mapController = controller;

    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Driver"
        ),
      ),
      body: SafeArea(
        child: appState.initialPosition == null
            ? Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitCircle(
                      color: Colors.black,
                      size: 50.0,
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Visibility(
                  visible: appState.locationServiceActive == false,
                  child: Text("Please enable location services!", style: TextStyle(color: Colors.grey, fontSize: 18),),
                )
              ],
            )
        )
            : Stack(
          children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                  target: appState.initialPosition, zoom: 10.0),
              onMapCreated: appState.onCreated,

              mapType: MapType.normal,
              compassEnabled: true,
              markers: Set.of(marker),
              onCameraMove: appState.onCameraMove,
              polylines: appState.polyLines,
            ),

            Positioned(
                top: 50.0,
                right: 15.0,
                left: 15.0,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 5.0),
                          blurRadius: 10,
                          spreadRadius: 3)
                    ],
                  ),
                  child: Center(
                    child:TextField(

                      cursorColor: Colors.black,
                      controller: appState.locationController,
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, top: 5),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.black,
                          ),
                        ),
                        hintText: "Pick up",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                      ),
                    ),
                  ),)

            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
                  Colors.limeAccent,
                  Colors.lightGreenAccent,
                ]),
              ),
              child:Container(
                child: Column(
                  children: <Widget>[
                    Material(
                      child: Padding(padding: EdgeInsets.all(6.0),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/logos/e.jpg'),
                          radius: 40.0,
                        ),
                      ) ,
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      elevation: 10 ,
                    ),
                    Padding(
                      padding: EdgeInsets.all(6.0),
                      child:  Text("EBMP",style: TextStyle(color: Colors.black,fontSize: 20.0,fontFamily: 'Billabong',fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),),

            CustomListTitle(Icons.person_outline,"Profile",(){
              Navigator.of(context).pushNamed('/profileDriver');}),
            CustomListTitle(Icons.notifications_none,"Notification",()=>{}),
            CustomListTitle(Icons.settings_applications,"Settings",()=>{}),
            CustomListTitle(Icons.lock_outline,"Log Out",(){
              Navigator.of(context).pushNamed('/dsignIn');}),

          ],
        ),
      ),
    );
  }
}


class CustomListTitle extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  CustomListTitle(this.icon,this.text,this.onTap);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child:Container(
        decoration: BoxDecoration(
            border : Border(bottom: BorderSide(color: Colors.lightGreenAccent))
        ),
        child:InkWell(
          splashColor: Colors.lightGreenAccent,
          onTap: (){Navigator.of(context).pushNamed(onTap());},
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Text(text,style: TextStyle(
                        fontSize: 16.0,
                      ),),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


