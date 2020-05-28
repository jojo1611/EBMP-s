import 'package:example/chatroom.dart';
import 'package:example/driverSignIn.dart';
import 'package:example/provider.dart';
import 'package:flutter/material.dart';
import 'auth_services.dart';
import 'profile.dart';
import 'profileDriver.dart';
import 'choose.dart';
import 'homeDriver.dart';
import 'home.dart';
import 'esingnup.dart';
import 'notification.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderClass(
        auth: AuthService(),
    child: MaterialApp(
    title: "EBMP App",
    theme: ThemeData(
    primarySwatch: Colors.green,
    ),
    home: HomeController(),
    routes: <String, WidgetBuilder>{
    '/signUp': (context) => SignUpView(authFormType: AuthFormType.signUp),
    '/signIn': (context) => SignUpView(authFormType: AuthFormType.signIn),
      '/dsignUp':(context)=>DriverSignUpView(authFormType: AuthFormTypeDriver.dsignUp,),
      '/dsignIn':(context)=>DriverSignUpView(authFormType: AuthFormTypeDriver.dsignIn,),
    '/home': (context) => Home(),
      '/profile': (context) => ProfileView(),
      '/profileDriver':(context)=>ProfileViewDriver(),
      '/choose':(context)=>Choose(),
      '/homeDriver':(context)=>HomeDriver(),
      '/notification':(context)=>FirebaseMessagingDemo(),
      '/chat':(context)=>ChatRoom(),
    },
    ));
  }
}
class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = ProviderClass.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? Choose() : SignUpView(authFormType: AuthFormType.signIn);
        }
        return CircularProgressIndicator();
      },
    );
  }
}