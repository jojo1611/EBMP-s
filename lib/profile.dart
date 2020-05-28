import 'package:flutter/material.dart';
import 'package:example/provider.dart';
import 'package:intl/intl.dart';


class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      backgroundColor: Colors.white,
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
    backgroundImage: AssetImage('assets/logos/rider.png'),
    radius: 40.0,
    ),
    ),
        Padding(
          padding: const EdgeInsets.all(10.0),

          child: Text("EBMP's Rider",style: TextStyle(fontFamily: 'Billabong',fontSize: 50.0,),),
          ),

      SizedBox(height: 30,),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 60.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.person),
                Text("   ${user.displayName ?? 'Anonymous'}", style: TextStyle(fontSize: 20),),
              ],
            )
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 60.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.email),
              Text("   ${user.email ?? 'Anonymous'}", style: TextStyle(fontSize: 20),),
            ],
          )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 60.0),
          child: Row(
            children: <Widget>[
            Icon(Icons.create),
            Text("  Install Date: ${DateFormat('dd/MM/yyyy').format(
            user.metadata.creationTime)}", style: TextStyle(fontSize: 20),),
      ],
    )

        ),
      ],
    );
  }

}