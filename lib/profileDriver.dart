import 'package:flutter/material.dart';
import 'package:example/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';


class ProfileViewDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        backgroundColor: Colors.blue[100],
        body:SingleChildScrollView(
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
              children: <Widget>[
                FutureBuilder(
                  future: ProviderClass
                      .of(context)
                      .auth
                      .getCurrentUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return displayUserInformation(context, snapshot);
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }

  Widget displayUserInformation(context, snapshot) {
    final user = snapshot.data;

    return Column(
      children: <Widget>[
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.all(10.0),

          child: CircleAvatar(
            backgroundImage: AssetImage('assets/logos/auto.png'),
            radius: 40.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),

          child: Text("EBMP's Driver",style: TextStyle(fontFamily: 'Billabong',fontSize: 50.0,),),
        ),

        SizedBox(height: 30,),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 120.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.person),
                Text("   ${user.displayName ?? 'Anonymous'}", style: TextStyle(fontSize: 20),),
              ],
            )
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 45.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.email),
                Text("   ${user.email ?? 'Anonymous'}", style: TextStyle(fontSize: 20),),
              ],
            )
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 90.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.create),
                Text("  Created: ${DateFormat('MM/dd/yyyy').format(
                    user.metadata.creationTime)}", style: TextStyle(fontSize: 20),),
              ],
            )

        ),
        SizedBox(
          height: 20,
        ),
        showSignOut(context, user.isAnonymous),
      ],
    );
  }

  Widget showSignOut(context, bool isAnonymous) {
    if (isAnonymous == true) {
      return RaisedButton(
        child: Text("Sign In To Save Your Data"),
        onPressed: () {
          Navigator.of(context).pushNamed('/convertUser');
        },
      );
    } else {
      return RaisedButton(
        child: Text("Sign Out"),
        onPressed: () async {
          try {
            await ProviderClass.of(context).auth.signOut();
          } catch (e) {
            print(e);
          }
        },
      );
    }
  }
}