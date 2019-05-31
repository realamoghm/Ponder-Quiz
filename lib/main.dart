import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponder_nlc/Colors.dart';
import 'package:ponder_nlc/optionSection.dart';
import 'package:ponder_nlc/settings.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

FirebaseUser user;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Start(),
    );
  }
}

final Start st = Start();
enum FormType { login, register }
String _email = "";
String _password = "";
FirebaseAuth _auth = FirebaseAuth.instance;

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  var url;
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final String top1 = 'assets/topSignInPage.svg';

  final String logo = 'assets/Logo.svg';

  final _random = new Random();

  final Firestore _db = Firestore.instance;

  final formKey = GlobalKey<FormState>();

  FormType _formType = FormType.login;
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print('Form is valid');
      return true;
    } else
      return false;
  }

  void createUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'lastSeen': DateTime.now(),
      'themePreference': colorVal
    }, merge: true);
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'lastSeen': DateTime.now(),
    }, merge: true);
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          user = await _auth.signInWithEmailAndPassword(
              email: _email, password: _password);
          updateUserData(user);
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new ListPage()));
        } else {
          user = await _auth.createUserWithEmailAndPassword(
              email: _email, password: _password);
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new ListPage()));
          createUserData(user);
        }
      } catch (e) {
        print('error');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SvgPicture.asset(
            top1,
            fit: BoxFit.fill,
            color: randColor[_random.nextInt(randColor.length)],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              SvgPicture.asset(
                logo,
                color: Colors.white,
              ),
              Text(
                "Welcome FBLA Ponderers",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18.0, fontFamily: "Viga", color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: createInputs(),
                  ),
                ),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: createButtons())
            ],
          ),
        ],
      ),
    );
  }


  List<Widget> createInputs() {
    return [
      new TextFormField(

        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
          validator: (value) {
            return value.isEmpty ? 'Email is required' : null;
          },
          onSaved: (value) {
            return _email = value;
          },
          decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.white),
              prefixIcon: Icon(MdiIcons.email,color: Colors.white,),
              focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    width: 4.0,
                    color: Colors.red)),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    width: 4.0,color: Colors.red)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(width: 4.0,color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(width: 4.0,color: Colors.white)))),
      Padding(
        padding: EdgeInsets.all(15.0),
      ),
      new TextFormField(
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        obscureText: true,
        validator: (value) {
          return value.isEmpty ? 'Password is required' : null;
        },
        onSaved: (value) {
          return _password = value;
        },
        decoration: new InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(MdiIcons.textboxPassword,color:Colors.white,),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    width: 4.0,
                    color: Colors.red)),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    width: 4.0,color: Colors.red)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(width: 4.0,color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(width: 4.0,color: Colors.white)))),
    ];
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            color: Colors.white,
            elevation: 5.0,
            child: Container(
              height: 50.0,
              width: 150.0,
              child: Center(
                child: Text('Login',
                
                style: TextStyle(
                  color: randColor[_random.nextInt(randColor.length)],
                  fontSize: 20.0),),
              )),
            onPressed: validateAndSubmit),
        Padding(
          padding: EdgeInsets.all(20.0),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(MdiIcons.google),
              color: orange,
              onPressed: (){url='https://tinyurl.com/ponderquizapp';
              _launchURL(url);
              },
            ),
            IconButton(
              icon: Icon(MdiIcons.facebook),
              color: Colors.blue[900],
              onPressed: (){url='https://www.facebook.com/ponder.quiz.1';
              _launchURL(url);},
            ),
            IconButton(
              icon: Icon(MdiIcons.instagram),
              color: Colors.white,
              onPressed: (){url='https://www.instagram.com/ponder_quiz_app/';
              _launchURL(url);},
            ),
            IconButton(
              icon: Icon(MdiIcons.twitter),
              color: Colors.lightBlue,
              onPressed: (){url='https://twitter.com/app_ponder';
              _launchURL(url);},
            ),
            IconButton(
              icon: Icon(MdiIcons.youtube),
              color: Colors.red,
              onPressed: (){url='https://www.youtube.com/channel/UCB1dFOCmanBH018udTEaUvQ';
              _launchURL(url);},
            ),
            IconButton(
              icon: Icon(MdiIcons.web),
              color: mint,
              onPressed: (){url='https://www.ponderquiz.com';
              _launchURL(url);},
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
        ),
        InkWell(
          onTap: moveToRegister,
          child: Container(
              alignment: Alignment.topCenter,
              child: Text(
                "New to Ponder? Register Here!",
                style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "MontserratAlternates-Semi",
                    color: lightBlue),
              )),
        )
      ];
    } else
      return [
            RaisedButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            color: Colors.white,
            elevation: 5.0,
            child: Container(
              height: 50.0,
              width: 150.0,
              child: Center(
                child: Text('Register',
                
                style: TextStyle(
                  color: randColor[_random.nextInt(randColor.length)],
                  fontSize: 20.0),),
              )),
            onPressed: validateAndSubmit),
        Padding(
          padding: EdgeInsets.all(20.0),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(MdiIcons.google),
              color: orange,
              onPressed: (){url='https://tinyurl.com/ponderquizapp';
              _launchURL(url);
              },
            ),
            IconButton(
              icon: Icon(MdiIcons.facebook),
              color: Colors.blue[900],
              onPressed: (){url='https://www.facebook.com/ponder.quiz.1';
              _launchURL(url);},
            ),
            IconButton(
              icon: Icon(MdiIcons.instagram),
              color: Colors.white,
              onPressed: (){url='https://www.instagram.com/ponder_quiz_app/';
              _launchURL(url);},
            ),
            IconButton(
              icon: Icon(MdiIcons.twitter),
              color: Colors.lightBlue,
              onPressed: (){url='https://twitter.com/app_ponder';
              _launchURL(url);},
            ),
            IconButton(
              icon: Icon(MdiIcons.youtube),
              color: Colors.red,
              onPressed: (){url='https://www.youtube.com/channel/UCB1dFOCmanBH018udTEaUvQ';
              _launchURL(url);},
            ),
            IconButton(
              icon: Icon(MdiIcons.web),
              color: mint,
              onPressed: (){url='https://www.ponderquiz.com';
              _launchURL(url);},
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
        ),
        InkWell(
          onTap: moveToLogin,
          child: Container(
              alignment: Alignment.topCenter,
              child: Text(
                "Already Have an Account? Login Here!",
                style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "MontserratAlternates-Semi",
                    color: lightBlue),
              )),
        )
      ];
  }
}
