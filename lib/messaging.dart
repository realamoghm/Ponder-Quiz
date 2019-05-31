import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ponder_nlc/main.dart';
import 'package:ponder_nlc/settings.dart';
import 'drawer.dart';
import 'Colors.dart';
import 'package:firebase_database/firebase_database.dart';

final PageController ctrl = PageController(viewportFraction: 0.5);

String eventName;
String _message;
Map<String, String> names;
enum FormType { regular }

final _random = new Random();

class DisplayEvent extends StatefulWidget {
  @override
  _DisplayEventState createState() => _DisplayEventState();
}

class _DisplayEventState extends State<DisplayEvent> {
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
        body: Column(
          children: <Widget>[
            Text('PonderChat',style: TextStyle(color: colorVal?Colors.white : dark,fontSize: 40.0),),
            Flexible(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.arrow_left,color:colorVal ? Colors.white : dark ,size: 20.0,),
                          Flexible(
                                                      child: StreamBuilder(
                stream: Firestore.instance.collection('events1').snapshots(),
                builder: (context, snapshot) {
                  return PageView.builder(
                    controller: ctrl,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data.documents[index];
                            return Center(
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 100, bottom: 100, right: 30, left: 30),
                                decoration: BoxDecoration(
                                  color: Colors.amberAccent,
                                  borderRadius: new BorderRadius.circular(20.0),
                                ),
                                child: InkWell(
                                    onTap: () {
                                      eventName = ds['name'];
                                      Navigator.of(context).push(new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new Messages()));
                                    },
                                    child: Center(
                                        child: Text(
                                      ds['name'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          fontFamily: 'MontserratAlternates-Bold',
                                          color: Colors.white),
                                    ))),
                              ),
                            );
                    },
                  );
                },
              ),
                          ),
              Icon(Icons.arrow_right,color:colorVal ? Colors.white : dark ,size: 20.0,),
                        ],
                      ),
            ),
          ],
        ));
  }
}

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final formKey = GlobalKey<FormState>();

  final Firestore _db = Firestore.instance;

  FormType _formType = FormType.regular;

  var now = new DateTime.now();
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
        updateUserData();
      } catch (e) {
        print('error');
      }
    }
  }

  void updateUserData() async {
    DocumentReference ref = _db.collection('events').document(eventName);

    return ref.updateData(
      {
        'message': FieldValue.arrayUnion([
          {
            'content': _message,
            'name': user.email.replaceAll("@gmail.com", ''),
            'time': now.hour.toString() + ':' + now.minute.toString()
          }
        ])
      },
    );
  }

  void _showDialog() {
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
                now = DateTime.now();
                validateAndSubmit();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:colorVal ? dark : Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorVal?Colors.white : dark,
        child: Center(
          child: Icon(MdiIcons.plus,color:colorVal ? dark : Colors.white ,),
        ),
        onPressed: () {
          _showDialog();
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
      body: Column(
        children: <Widget>[
          Flexible(
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('events')
                    .document(eventName)
                    .snapshots(),
                builder: (context, snapshot) {
                  return Center(
                    child: snapshot.data['message'] == null
                        ? Text(
                            'Nothing Here Start Talking With The FBLA Community!')
                        : ListView.builder(
                            shrinkWrap: true,
                            controller: _scrollController,
                            itemCount: snapshot.data['message'].length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 20.0,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            child: Text(snapshot.data['message']
                                                [index]['name']),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            radius: 25.0,
                                            backgroundColor: randColor[_random
                                                .nextInt(randColor.length)],
                                            child: Text(
                                              snapshot.data['message'][index]
                                                      ['name']
                                                  .toString()
                                                  .substring(0, 1),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.all(10.0),
                                            child: Text(snapshot.data['message']
                                                [index]['content']),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            child: Text(
                                              snapshot.data['message'][index]
                                                      ['time']
                                                  .toString(),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                    )
                                  ],
                                ),
                              );
                            }),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
