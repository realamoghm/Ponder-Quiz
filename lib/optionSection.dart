import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ponder_nlc/Colors.dart';
import 'package:ponder_nlc/drawer.dart';
import 'package:ponder_nlc/main.dart';
import 'package:ponder_nlc/presentationSection.dart';
import 'package:ponder_nlc/quizListDetail.dart';
import 'package:ponder_nlc/settings.dart';




int _selectedPage = 0;

final _pageOptions = [
  QuizListDetail(),PresentationSection()
  
];





class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:()async=> false,
          child: 
               Scaffold(
        backgroundColor: colorVal? dark : Colors.white,
        appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              iconTheme: IconThemeData(color: colorVal? Colors.white : dark),
        ),
        drawer: drawer(context),
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: Theme(
         data: Theme.of(context).copyWith(
        // sets the background color of the `BottomNavigationBar`
        canvasColor: colorVal? dark : Colors.white,
        // sets the active color of the `BottomNavigationBar` if `Brightness` is light
        primaryColor: orange,
        textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: colorVal? Colors.white : dark))),
                      child: BottomNavigationBar(
                currentIndex: _selectedPage,
                onTap: (int index){
                  setState(() {
                   _selectedPage=index; 
                  });
                },
                items: [
                  BottomNavigationBarItem(
                  icon: Icon(Icons.phone_android),
                  title: Text('Quiz'),),
                  BottomNavigationBarItem(
                  icon: Icon(Icons.developer_board),
                  title: Text('Presentation')
                
              )]),
        )
      )
    );
  }
}



        