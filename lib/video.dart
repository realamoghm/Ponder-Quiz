import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ponder_nlc/Colors.dart';
import 'package:ponder_nlc/drawer.dart';
import 'package:ponder_nlc/settings.dart';

bool vars;
String link;
 final _random = new Random();

class Video extends StatelessWidget {
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
        body: StreamBuilder(
            stream: Firestore.instance.collection('videos').snapshots(),
            builder: (context, snapshot) {
              DocumentSnapshot ds = snapshot.data.documents[0];
              vars = ds['live'];
              if (vars == true) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color:randColor[_random.nextInt(randColor.length)],
                    borderRadius: new BorderRadius.circular(20.0),
                  ),
                  child: InkWell(
                      onTap: () {
                        link = ds['link'];
                        Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new LiveVideo()));},
                      child: Column(children: [
                        
                        Text(ds['name'],style: TextStyle(
                                                              color: Colors.white,
                                                              fontFamily: "Viga",
                                                              fontSize: 20.0),textAlign: TextAlign.left,),
                        Padding(padding: EdgeInsets.all(10.0),),
                        Text(
                          ds['description'],
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(MdiIcons.circle,color: Colors.red,),
                            Text('Live',style: TextStyle(
                                                              color: Colors.white,
                                                              fontFamily: "Viga",
                                                              fontSize: 20.0),textAlign: TextAlign.left,)
                          ],
                        )
                      ])),
                );
              }
            }));
  }
}

class LiveVideo extends StatefulWidget {
  @override
  _LiveVideoState createState() => _LiveVideoState();
}

class _LiveVideoState extends State<LiveVideo> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
          onWillPop: () async => true,
          child: Scaffold(
        body:  FlutterYoutube.playYoutubeVideoById(
            apiKey: "AIzaSyCad5Ffot2Hz_OBYmN2D4Axw95PdzZf15s",
            videoId: link,
            autoPlay: false, //default falase
            fullScreen: false //default false
            
      )
      ),
    );}
}

