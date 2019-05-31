import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponder_nlc/Colors.dart';
import 'package:ponder_nlc/main.dart';
import 'package:ponder_nlc/quizGeneralLayout.dart';
import 'package:ponder_nlc/settings.dart';

String url;


Widget networkSvg(ds) {
  return SvgPicture.network(
    ds['pictureUrl'],
    alignment: Alignment.topLeft,
    semanticsLabel: 'A shark?!',
    placeholderBuilder: (BuildContext context) => new Container(
        padding: const EdgeInsets.all(30.0),
        child: const CircularProgressIndicator()),
  );
}

class QuizListDetail extends StatefulWidget {
  @override
  QuizListDetailState createState() => QuizListDetailState();
}

class QuizListDetailState extends State<QuizListDetail> {


  @override
  Widget build(BuildContext context) {
        
            return Scaffold(
              backgroundColor: colorVal? dark : Colors.white,
                  body: Column(
                    children: <Widget>[
                      Card(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(20.0)),
                                        child: Container(
                                          height: 65.0,
                                          width: 330.0,
                                          decoration: BoxDecoration(
                                              borderRadius: new BorderRadius.circular(20.0),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                darkPurple,
                                                purple,
                                                lightBlue
                                              ])),
                                          child:
                                          Center(child: Text('29 Days till FBLA Nationals!',textAlign: TextAlign.center,style: TextStyle(color: Colors.white)))
                                          )),
                      Padding(padding: EdgeInsets.all(10.0),),
                      Flexible(
                          child: StreamBuilder(
                            stream: Firestore.instance.collection('options').orderBy('name').snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return CircularProgressIndicator();
                              return new ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot ds = snapshot.data.documents[index];
                                  return InkWell(
                                    borderRadius: new BorderRadius.circular(20.0),
                                    highlightColor: Colors.white,
                                    onTap: () {
                                      url = ds['JsonUrl'];
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) => new Quiz1()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        elevation: 20.0,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(20.0)),
                                        child: Container(
                                          height: 154.0,
                                          decoration: BoxDecoration(
                                              borderRadius: new BorderRadius.circular(20.0),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                Color(ds['color1']),
                                                Color(ds['color2'])
                                              ])),
                                          child: 
                                              Padding(
                                                padding: const EdgeInsets.only(left:14.0,top:11.0,bottom: 10.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      
                                                      alignment: Alignment.centerLeft,
                                                      child: networkSvg(ds)),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(top: 10.0),
                                                      child: Container(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                          ds['name'],
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontFamily: "Viga",
                                                              fontSize: 20.0),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                        
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
            );
          }
      
}