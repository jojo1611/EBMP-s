
import 'package:example/database.dart';
import 'package:example/helper.dart';
import 'package:flutter/material.dart';
import 'package:example/auth_services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:example/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'choose.dart';
import 'helper.dart';

// TODO move this to tone location
final primaryColor = const Color(0xFF75A2EA);

enum AuthFormTypeDriver { dsignIn, dsignUp, dreset, anonymous, convert }

class DriverSignUpView extends StatefulWidget {
  final AuthFormTypeDriver authFormType;

  DriverSignUpView({Key key, @required this.authFormType}) : super(key: key);

  @override
  _DriverSignUpViewState createState() =>
      _DriverSignUpViewState(authFormType: this.authFormType);
}

class _DriverSignUpViewState extends State<DriverSignUpView> {
  AuthFormTypeDriver authFormType;

  @override
  _DriverSignUpViewState({this.authFormType});

  final formKey = GlobalKey<FormState> ( );
  String _email , _password , _name , _warning , _phone;
  DatabaseMethods databaseMethods = new DatabaseMethods( );
  Helper helper = new Helper();
  void switchFormState(String state) {
    formKey.currentState.reset ( );
    if (state == "signUp") {
      setState ( () {
        authFormType = AuthFormTypeDriver.dsignUp;
      } );
    } else if (state == 'home') {
      Navigator.of ( context ).pop ( );
    } else {
      setState ( () {
        authFormType = AuthFormTypeDriver.dsignIn;
      } );
    }
  }

  bool validate() {
    final form = formKey.currentState;
    if (authFormType == AuthFormTypeDriver.anonymous) {
      return true;
    }
    form.save ( );
    if (form.validate ( )) {
      form.save ( );
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate ( )) {
      try {
        final auth = ProviderClass
            .of ( context )
            .auth;
        switch (authFormType) {
          case AuthFormTypeDriver.dsignIn:
            Helper.saveUserEmailSharedPreference(_email);
            await auth.signInWithEmailAndPassword ( _email , _password ).then((val){
              if(val != null){
                Helper.saveUserLoggedInSharedPreference(true);
                Navigator.of ( context ).pushReplacementNamed ( '/homeDriver' );
              }
            });

            break;
          case AuthFormTypeDriver.dsignUp:
            await auth.createUserWithEmailAndPassword (
                _email , _password , _name );

            if (Choose ( ).cho == Choose ( ).driver) {
              Map<String , String> driverInfoMap = {
                "DriverName": _name ,
                "DriverEmail": _email
              };

              databaseMethods.uploadDriverInfo ( driverInfoMap );
            }
            Helper.saveUserEmailSharedPreference(_email);
            Helper.saveUserNameSharedPreference(_name);

            Helper.saveUserLoggedInSharedPreference(true);

            Navigator.of ( context ).pushReplacementNamed ( '/homeDriver' );
            break;
          case AuthFormTypeDriver.dreset:
            await auth.sendPasswordResetEmail ( _email );
            setState ( () {
              _warning = "A password reset link has been sent to $_email";
              authFormType = AuthFormTypeDriver.dsignIn;
            } );
            break;
          case AuthFormTypeDriver.anonymous:
            await auth.singInAnonymously ( );
            Navigator.of ( context ).pushReplacementNamed ( '/homeDriver' );
            break;
          case AuthFormTypeDriver.convert:
            await auth.convertUserWithEmail (
                _email , _password , _name);
            Navigator.of ( context ).pop ( );
            break;
        }
      } catch (e) {
        print ( e );
        setState ( () {
          _warning = e.message;
        } );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery
        .of ( context )
        .size
        .width;
    final _height = MediaQuery
        .of ( context )
        .size
        .height;

    if (authFormType == AuthFormTypeDriver.anonymous) {
      submit ( );
      return Scaffold (
          backgroundColor: primaryColor ,
          body: SingleChildScrollView (
            child: Column (
              mainAxisAlignment: MainAxisAlignment.center ,
              children: <Widget>[
                SpinKitDoubleBounce (
                  color: Colors.white ,
                ) ,
                Text (
                  "Loading" ,
                  style: TextStyle ( color: Colors.white ) ,
                ) ,
              ] ,
            ) ,
          ) );
    } else {
      return Scaffold (
        body: SingleChildScrollView (
          child: Container (
            color: primaryColor ,
            height: _height ,
            width: _width ,
            child: SafeArea (
              child: Column (
                children: <Widget>[
                  SizedBox ( height: _height * 0.025 ) ,
                  showAlert ( ) ,
                  SizedBox ( height: _height * 0.025 ) ,
                  buildHeaderText ( ) ,
                  SizedBox ( height: _height * 0.05 ) ,
                  Padding (
                    padding: const EdgeInsets.all( 20.0 ) ,
                    child: Form (
                      key: formKey ,
                      child: Column (
                        children: buildInputs ( ) + buildButtons ( ) ,
                      ) ,
                    ) ,
                  ) ,
                ] ,
              ) ,
            ) ,
          ) ,
        ) ,
      );
    }
  }

  Widget showAlert() {
    if (_warning != null) {
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
                _warning ,
                maxLines: 3 ,
              ) ,
            ) ,
            Padding (
              padding: const EdgeInsets.only( left: 8.0 ) ,
              child: IconButton (
                icon: Icon ( Icons.close ) ,
                onPressed: () {
                  setState ( () {
                    _warning = null;
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

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormTypeDriver.dsignIn) {
      _headerText = "EBMP Sign In";
    } else if (authFormType == AuthFormTypeDriver.dreset) {
      _headerText = "Reset Password";
    } else {
      _headerText = "Create New Account";
    }
    return AutoSizeText (
      _headerText ,
      maxLines: 1 ,
      textAlign: TextAlign.center ,
      style: TextStyle (
        fontSize: 35 ,
        fontFamily: 'Billabong' ,
        color: Colors.white ,
      ) ,
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];
    if (authFormType == AuthFormTypeDriver.dreset) {
      textFields.add (
        TextFormField (
          validator: EmailValidator.validate ,
          style: TextStyle ( fontSize: 20.0 ) ,
          decoration: buildSignUpInputDecoration ( "Email" ) ,
          onSaved: (value) => _email = value ,
        ) ,

      );
      return textFields;
    }
    // if were in the sign up state add name
    if ([AuthFormTypeDriver.dsignUp , AuthFormTypeDriver.convert].contains (
        authFormType )) {
      textFields.add (
        TextFormField (
          validator: NameValidator.validate ,
          style: TextStyle ( fontSize: 20.0 ) ,
          decoration: buildSignUpInputDecoration ( "Name" ) ,
          onSaved: (value) => _name = value ,
        ) ,
      );
      textFields.add ( SizedBox ( height: 20 ) );
    }

    // add email & password
    textFields.add(
      TextFormField(
        validator: EmailValidator.validate,
        style: TextStyle(fontSize: 20.0),
        decoration: buildSignUpInputDecoration("Email"),
        onSaved: (value) => _email = value,
      ),
    );
    textFields.add(SizedBox(height: 20));
    textFields.add(
      TextFormField(
        validator: PasswordValidator.validate,
        style: TextStyle(fontSize: 20.0),
        decoration: buildSignUpInputDecoration("Password"),
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    );
    textFields.add(SizedBox(height: 20));

    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0)),
      contentPadding:
      const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
    );
  }

  List<Widget> buildButtons() {
    String _switchButtonText, _newFormState, _submitButtonText;
    bool _showForgotPassword = false;
    bool _showSocial = true;

    if (authFormType == AuthFormTypeDriver.dsignIn) {
      _switchButtonText = "Create New Account";
      _newFormState = "signUp";
      _submitButtonText = "Sign In";
      _showForgotPassword = true;
    } else if (authFormType == AuthFormTypeDriver.dreset) {
      _switchButtonText = "Return to Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Submit";
      _showSocial = false;
    } else if (authFormType == AuthFormTypeDriver.convert) {
      _switchButtonText = "Cancel";
      _newFormState = "home";
      _submitButtonText = "Sign Up";
    } else {
      _switchButtonText = "Have an Account? Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Sign Up";
    }

    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.white,
          textColor: primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _submitButtonText,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          onPressed: submit,
        ),
      ),
      showForgotPassword(_showForgotPassword),
      FlatButton(
        child: Text(
          _switchButtonText,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          switchFormState(_newFormState);
        },
      ),

      buildSocialIcons(_showSocial),
    ];
  }

  Widget showForgotPassword(bool visible) {
    return Visibility(
      child: FlatButton(
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            authFormType = AuthFormTypeDriver.dreset;
          });
        },
      ),
      visible: visible,
    );
  }

  Widget buildSocialIcons(bool visible) {
    final _auth = ProviderClass.of(context).auth;
    return Visibility(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Divider(
            color: Colors.white,
          ),
          SizedBox(height: 10),
          GoogleSignInButton(
            onPressed: () async {
              try {
                if(authFormType == AuthFormTypeDriver.convert) {
                  await _auth.convertWithGoogle();
                  Navigator.of(context).pop();
                } else {
                  await _auth.signInWithGoogle();
                  Navigator.of(context).pushReplacementNamed('/homeDriver');
                }
              } catch (e) {
                setState(() {
                  print(e);
                  _warning = e.message;
                });
              }
            },
          ),
        ],
      ),
      visible: visible,
    );
  }

}