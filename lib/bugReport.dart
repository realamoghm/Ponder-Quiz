import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ponder_nlc/Colors.dart';
import 'package:ponder_nlc/drawer.dart';
import 'package:ponder_nlc/settings.dart';

final _random = new Random();

 final formKey = GlobalKey<FormState>();
 String _message;
 final Firestore _db = Firestore.instance;

class BugReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorVal ? dark : Colors.white,
      appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                iconTheme: IconThemeData(color: colorVal ? Colors.white : dark),
              ),
      drawer: drawer(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorVal?Colors.white : dark,
        child: Center(
          child: Icon(MdiIcons.plus,color:colorVal ? dark : Colors.white ,),
        ),
        onPressed: () {
          _showDialog(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 50.0,
        child: Container(
          height: 60.0,
          color: randColor[_random.nextInt(randColor.length)],
        ),
      ),
      body: Center(child: Container(child: Text('Report Bugs Here!',style: TextStyle(color: colorVal ? Colors.white : dark,fontSize: 30.0),),),)
    );
    
  }
  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: randColor[_random.nextInt(randColor.length)],
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
          title: new Text(
            "New Message",
            style: TextStyle(color: Colors.white),
          ),
          content: Form(
            key: formKey,
            child: new TextFormField(
              autocorrect: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              onSaved: (value) {
                return _message = value;
              },
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Send",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                validateAndSubmit();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print('Form is valid');
      return true;
    } else
      return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        updateBug();
      } catch (e) {
        print('error');
      }
    }
  }
  void updateBug() async {
    DocumentReference ref = _db.collection('bugs').document('jVONPAOUG7ZO2j4WCgIT');

    return ref.updateData(
      {
        'message': FieldValue.arrayUnion([_message])
      },
    );
  }
}