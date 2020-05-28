
import 'package:flutter/material.dart';
import 'package:example/database.dart';

class Choose extends StatelessWidget {
  DatabaseMethods databaseMethods =  new DatabaseMethods();
  String choice,rider,driver,cho;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 80.0,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'You Wanna Drive Or Ride?',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Billabong',
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Padding(padding: EdgeInsets.all(20)),
                  Material(
                    child: Padding(padding: EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/logos/rider1.jpg'),
                        radius: 40.0,
                      ),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    elevation: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(6.0),
                    child:RaisedButton(onPressed: (){
                      choice = rider;

                      Navigator.of(context).pushNamed('/signIn');},
                      child:Text("RIDE", style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,),),
                    ),),
                  SizedBox(
                    height: 10,
                  ),
                  Material(
                    child: Padding(padding: EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/logos/driver.png'),
                        radius: 40.0,
                      ),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    elevation: 10,
                  ),

                  Padding(
                    padding: EdgeInsets.all(6.0),
                    child:RaisedButton(onPressed: (){
                      cho = driver;
                      Navigator.of(context).pushNamed('/dsignIn');},
                      child: Text("DRIVE", style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,),),
                    ),
                  ),

                ]
            ),
          ),),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter ,
                end: Alignment.bottomCenter,
                colors:[
                  Colors.blue[50],
                  Colors.blue[200],
                  Colors.blue[300],
                  Colors.blue,
                ])
        ),
      ),
    );
  }
}
