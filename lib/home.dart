import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:example/app_State.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey:"AIzaSyDnX9ZnR0eRStKd6tEMMOuWUBUKfKYbjhM");


  void onMapCreated(GoogleMapController controller){
    setState(() {
      mapController = controller;

    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    String warning;
    Widget showAlert() {
      if (warning != null) {
        return Container (
          color: Colors.amberAccent ,
          width: double.infinity ,
          padding: EdgeInsets.all ( 8.0 ) ,
          child: Row (
            children: <Widget>[
              Padding (
                padding: const EdgeInsets.only( right: 8.0 ) ,
                child: Icon ( Icons.error_outline ) ,
              ) ,
              Expanded (
                child: AutoSizeText (
                  warning ,
                  maxLines: 3 ,
                ) ,
              ) ,
              Padding (
                padding: const EdgeInsets.only( left: 8.0 ) ,
                child: IconButton (
                  icon: Icon ( Icons.close ) ,
                  onPressed: () {
                    setState ( () {
                      warning = null;
                    } );
                  } ,
                ) ,
              )
            ] ,
          ) ,
        );
      }
      return SizedBox (
        height: 0 ,
      );
    }
    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Rider"
        ),
      ),
      body:SafeArea(
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
              compassEnabled: true,
              initialCameraPosition: CameraPosition(
                  target: appState.initialPosition, zoom: 10.0),
              onMapCreated: appState.onCreated,

              mapType: MapType.terrain,

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
                          offset: Offset(20.0, 5.0),
                          blurRadius: 10,
                          spreadRadius: 3)
                    ],
                  ),
                  child: Center(
                    child:TextField(

                      cursorColor: Colors.black,
                      controller: appState.locationController,
                      decoration: InputDecoration(
                        hintText: "Pick up",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                        icon: Container(
                          margin: EdgeInsets.only(left: 110, top: 5),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.black,
                          ),
                        ),


                      ),
                    ),
                  ),)

            ),
            Positioned(
              top: 120.0,
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
                    child: DropdownButton(

                      icon: Icon(Icons.location_city),
                      hint: Text('Drop Location'), // Not necessary for Option 1
                      value: selectedLocation,
                      onChanged: (newValue) {
                        setState(() {

                          selectedLocation = newValue;
                          if(selectedLocation == _locations[0]){
                            _origin = LatLng(30.351929, 76.364669);

                          }
                          if(selectedLocation == _locations[1]) {
                            _origin = LatLng ( 30.351381 , 76.363198 );
                          }
                          if(selectedLocation == _locations[2]){
                            _origin = LatLng(30.351190, 76.361327);

                          }
                          if(selectedLocation == _locations[3]){
                            _origin = LatLng(30.351412, 76.359771);

                          }

                          marker.add(Marker(
                            markerId: MarkerId('Drop Location'),
                            draggable: false,
                            onTap: (){
                              print('Marker Tapped');
                            },
                            position: _origin,
                          ));

                        });
                      },
                      items: _locations.map((location) {
                        return DropdownMenuItem(
                          child: new Text(location),
                          value: location,
                        );
                      }).toList(),
                    ),
                  )
              ),
            ),
SizedBox(height: 100,),
       Positioned(

         top: 700.0,
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
               child:Container(
           child: FlatButton(
             onPressed: (){
              setState(() {
                warning = "Request is sent to Drivers";
              });

              showAlert();
             },
             child: Text("Ride Now",style: TextStyle(
               fontWeight: FontWeight.bold,

             )
             ,),
           ),
         )
          ),
         ),
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
              Navigator.of(context).pushNamed('/profile');}),
            CustomListTitle(Icons.notifications_none,"Notification",(){Navigator.of(context).pushNamed('/notification');}),
            CustomListTitle(Icons.chat_bubble_outline,"Chat",(){
              Navigator.of(context).pushNamed('/chat');}),
            CustomListTitle(Icons.lock_outline,"Log Out",(){Navigator.of(context).pushNamed('/signIn');}),

          ],
        ),
      ),

    );

  }
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  void MapCreated(GoogleMapController controller) {
    mapController=controller;

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
