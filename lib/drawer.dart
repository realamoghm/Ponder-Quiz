

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ponder_nlc/Colors.dart';
import 'package:ponder_nlc/bugReport.dart';
import 'package:ponder_nlc/main.dart';
import 'package:ponder_nlc/messaging.dart';
import 'package:ponder_nlc/optionSection.dart';
//import 'package:ponder_nlc/messaging.dart';
import 'package:ponder_nlc/settings.dart';
import 'package:ponder_nlc/video.dart';


Widget svg1(ds) {
  return SvgPicture.network(
    'https://firebasestorage.googleapis.com/v0/b/ponder-d9c31.appspot.com/o/Logo.svg?alt=media&token=3c51d01a-d028-4c80-897a-4b1a5022ba99',
    color: lightBlue,
    alignment: Alignment.center,
    semanticsLabel: 'A shark?!',
    placeholderBuilder: (BuildContext context) => new Container(
        padding: const EdgeInsets.all(30.0),
        child: const CircularProgressIndicator()),
  );
}


Widget drawer(context) => 
         Theme(
  data: Theme.of(context).copyWith(
        // sets the background color of the `BottomNavigationBar`
        canvasColor:colorVal? dark : Colors.white,
        // sets the active color of the `BottomNavigationBar` if `Brightness` is light
        primaryColor: lightBlue,
        textTheme: Theme
            .of(context)
            .textTheme
            .copyWith(caption: new TextStyle(color: Colors.white))),
    child:Drawer(
      elevation: 0.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
         svg1(context),
         ListTile(
              trailing: Icon(
                Icons.home,
                color: mint,
              ),
              title: Text(
                'Home',
                style: TextStyle(
                  color: colorVal? Colors.white : dark,
                    fontSize: 20.0,
                    fontFamily: 'MontserratAlternates-SemiBold'),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new ListPage()));
              }),
          ListTile(
              trailing: Icon(
                Icons.settings,
                color: green,
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                  color: colorVal? Colors.white : dark,
                    fontSize: 20.0,
                    fontFamily: 'MontserratAlternates-SemiBold'),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new Settings()));
              }),
          ListTile(
            onTap: (){Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new DisplayEvent()));},
            trailing: Icon(
              Icons.message,
              color: orange,
            ),
            title: Text(
              'PonderChat',
              style: TextStyle(
                color: colorVal? Colors.white : dark,
                  fontSize: 20.0, fontFamily: 'MontserratAlternates-SemiBold'),
            ),
          ),
          ListTile(
       
            trailing: Icon(
              Icons.video_library,
              color: red,
            ),
            title: Text(
              'Videos',
              style: TextStyle(
                color: colorVal? Colors.white : dark,
                  fontSize: 20.0, fontFamily: 'MontserratAlternates-SemiBold'),
            ),
            onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new Video()));
              }),
              ListTile(
            trailing: Icon(
              Icons.bug_report,
              color: lightBlue,
            ),
            onTap: (){
              Navigator.pop(context);
              Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new BugReport()));
            },
            title: Text(
              'Bug Report',
              style: TextStyle(
                color: colorVal? Colors.white : dark,
                  fontSize: 20.0, fontFamily: 'MontserratAlternates-SemiBold'),
            ),
          ),
          ListTile(
            trailing: Icon(
              Icons.info,
              color: red,
            ),
            onTap: (){
              FirebaseAuth.instance.signOut();
              Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new Start()));
            },
            title: Text(
              'Sign Out',
              style: TextStyle(
                color: colorVal? Colors.white : dark,
                  fontSize: 20.0, fontFamily: 'MontserratAlternates-SemiBold'),
            ),
          ),
          
        ],
      ),
    ));
