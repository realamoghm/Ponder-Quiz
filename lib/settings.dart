import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ponder_nlc/drawer.dart';
import 'package:ponder_nlc/main.dart';
import 'Colors.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

bool colorVal = false;
final Firestore _db = Firestore.instance;

class SettingsState extends State<Settings> {
  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({'themePreference': colorVal}, merge: true);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          colorVal = snapshot.data['themePreference'];
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                iconTheme: IconThemeData(color: colorVal ? Colors.white : dark),
              ),
              drawer: drawer(context),
              backgroundColor: colorVal ? dark : Colors.white,
              body: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    colorVal == true
                        ? Text(
                            'Disable Dark Mode',
                            style: TextStyle(
                                color: colorVal ? Colors.white : dark,
                                fontSize: 20.0,
                                fontFamily: 'MontserratAlternates-SemiBold'),
                          )
                        : Text('Enable Dark Mode',
                            style: TextStyle(
                                color: colorVal ? Colors.white : dark,
                                fontSize: 20.0,
                                fontFamily: 'MontserratAlternates-SemiBold')),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                    ),
                    Switch(
                      onChanged: (value) {
                        setState(() {
                          colorVal = value;
                          updateUserData(user);
                        });
                      },
                      value: colorVal,
                    ),
                  ],
                ),
              ]));
        });
  }
}
