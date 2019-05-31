    
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ponder_nlc/Colors.dart';
import 'package:ponder_nlc/main.dart';
import 'package:ponder_nlc/optionSection.dart';
import 'package:ponder_nlc/quizListDetail.dart';
import 'package:ponder_nlc/once_future_builder.dart';
import 'package:ponder_nlc/settings.dart';

var finalScore = 0;
var questionNumber = 0;

Color a = Colors.black;
Color b = Colors.black;
Color c = Colors.black;
Color d = Colors.black;


class Quiz1 extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new Quiz1State();
  }
}

class Quiz1State extends State<Quiz1> {
  List data;
    Future getJsonData()async{     
      var response = await http.get(url);
      print(response.body);
      setState(() {
       var convertDataToJson= json.decode(response.body);
       data = convertDataToJson["results"]; 
      });
        
    }
  
  
  
  
  
    @override
    void initState() {
      super.initState();
      a = orange;
      b = orange;
      c = orange;
      d = orange;
      getJsonData();
      
    }
  
  
  
  
    @override
    Widget build(BuildContext context) {
      return new WillPopScope(
          onWillPop: () async => true,
          child: StreamBuilder(
            stream: Firestore.instance.collection('users').document(user.uid).snapshots(),
          builder: (context, snapshot) {
            colorVal=snapshot.data['themePreference'];
              return Scaffold(
                backgroundColor:colorVal? dark : Colors.white,
                body:
                     OnceFutureBuilder(
                      future: ()=>getJsonData(),
                       builder: (context, snapshot) {
                         if (snapshot.connectionState != ConnectionState.done) {
                     return Center(child: CircularProgressIndicator(backgroundColor: Colors.blue));
                    } else {
                         return new Container(
                          margin: const EdgeInsets.all(10.0),
                          alignment: Alignment.topCenter,
                          child: new Column(
                            children: <Widget>[
                              new Padding(padding: EdgeInsets.all(20.0)),
  
                              new Container(
                                alignment: Alignment.centerRight,
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
  
                                    new Text("Question ${questionNumber + 1} of ${data.length}",
                                      style: new TextStyle(
                                          color: lightBlue,
                                                      fontFamily: "Viga",
                                                      fontSize: 20.0
                                      ),),
                                    new Text("Score: $finalScore",
                                      style: new TextStyle(
                                          color: lightBlue,
                                                      fontFamily: "Viga",
                                                      fontSize: 20.0
                                      ),)
                                  ],
                                ),
                              ),  
                              new Padding(padding: EdgeInsets.all(10.0)),
  
                              Container(
                                margin: EdgeInsets.all(5.0),
                                padding: EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(20.0),
                                color: colorVal? Colors.white : dark,
                                ),
                                child: new Text(
                                  
                                  data[questionNumber]["question"],
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                    color: colorVal? dark : Colors.white,
                                                        fontFamily: "Viga",
                                                        fontSize: 20.0
                                  ),),
                              ),
  
                              new Padding(padding: EdgeInsets.all(10.0)),
  
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
  
                                  //button 1
                                  Container(
                                    width: 300.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.circular(20.0),
                                    ),
                                    child: new RaisedButton(
                                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                                      color: a,
                                      elevation: 5.0,
                                      onPressed: (){
                                        optionA();
                                        moveOn();
                                      },
                                      child: new Text(data[questionNumber]["choices"][0],
                                        style: new TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white
                                        ),),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(10.0),),
                                  //button 2
                                  Container(
                                    width: 300.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.circular(20.0), 
                                    ),
                                    child: new RaisedButton(
                                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                                      color: b,
                                      elevation: 5.0,
                                      onPressed: (){
  
                                        optionB();
                                        moveOn();
                                      },
                                      child: new Text(data[questionNumber]["choices"][1],
                                        style: new TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white
                                        ),),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(10.0),),
                                  //button 3
                                  Container(
                                    width: 300.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.circular(20.0), 
                                    ),
                                    child: new RaisedButton(
                                     shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                                      color: c,
                                      elevation: 5.0,
                                      onPressed: (){
  
                                        optionC();
                                        moveOn();
                                      },
                                      child: new Text(data[questionNumber]["choices"][2],
                                        style: new TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white
                                        ),),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(10.0),),
                                  //button 4
                                  Container(
                                    width: 300.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.circular(20.0), 
                                    ),
                                    child: new RaisedButton(
                                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                                      color: d,
                                      elevation: 5.0,
                                      onPressed: (){
                                        optionD();
                                        
                                        moveOn();
                                      },
                                      child: new Text(data[questionNumber]["choices"][3],
                                        style: new TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white
                                        ),),
                                    ),
                                  ),
  
                                ],
                              ),
  
                              new Padding(padding: EdgeInsets.all(15.0)),
  
                              new Container(
                                alignment: Alignment.bottomCenter,
                                child:  new RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(20.0)),
                                    color: colorVal? Colors.white : dark,
                                    onPressed: resetQuiz,
                                    child: new Text("Quit",
                                      style: new TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.redAccent
                                      ),)
                                )
                              ),
  
  
  
  
                            ],
                          ),
                    );
                       }
                       })
                  
  
        );
            }
          )
      );
    }
  
  void optionA(){
    if(data[questionNumber]["choices"][0] == data[questionNumber]["correct_answer"]){
                            setState(() {
                             a=green; 
                            });
                            
                            debugPrint("Correct");
                            finalScore++;
                          }else{
                            setState(() {
                             a=Colors.red; 
                            });
                            check();
                            debugPrint("Wrong");
                          }
  }
  void optionB(){
    if(data[questionNumber]["choices"][1] == data[questionNumber]["correct_answer"]){
                            setState(() {
                             b=green; 
                            });
                            
                            debugPrint("Correct");
                            finalScore++;
                          }else{
                            setState(() {
                             b=Colors.red; 
                            });
                            check();
                            debugPrint("Wrong");
                          }
  }
  void optionC(){
    if(data[questionNumber]["choices"][2] == data[questionNumber]["correct_answer"]){
                            setState(() {
                             c=green; 
                            });
                            
                            debugPrint("Correct");
                            finalScore++;
                          }else{
                            setState(() {
                             c=Colors.red; 
                            });
                            check();
                            debugPrint("Wrong");
                          }
  }
  void optionD(){
    if(data[questionNumber]["choices"][3] == data[questionNumber]["correct_answer"]){
                            setState(() {
                             d=green; 
                            });
                            
                            debugPrint("Correct");
                            finalScore++;
                          }else{
                            setState(() {
                             d=Colors.red; 
                            });
                            check();
                            debugPrint("Wrong");
                          }
  }
  
  void resetQuiz(){
      setState(() {
        Navigator.pop(context);
        finalScore = 0;
        questionNumber = 0;
      });
    }
  
  void moveOn(){
    Future.delayed(Duration(seconds: 2),(){updateQuestion();
                           setState(() {
                            a =orange; 
                            b =orange; 
                            c =orange; 
                            d =orange; 
                           });
                           });
  }
  
  void updateQuestion(){
      setState(() {
        if(questionNumber == data.length - 1){
          Navigator.push(context, new MaterialPageRoute(builder: (context)=> new Summary(score: finalScore,)));
  
        }else{
          questionNumber++;
        }
      });
    }
  
  void check(){
      Future.delayed(Duration(milliseconds: 500),(){
            if(data[questionNumber]["choices"][0] == data[questionNumber]["correct_answer"]){
        setState(() {
         a = Colors.green; 
        });
      }
      else if(data[questionNumber]["choices"][1] == data[questionNumber]["correct_answer"]){
        setState(() {
         b = Colors.green; 
        });
      }
      else if(data[questionNumber]["choices"][2] == data[questionNumber]["correct_answer"]){
        setState(() {
         c = Colors.green; 
        });
      }
      else if(data[questionNumber]["choices"][3] == data[questionNumber]["correct_answer"]){
        setState(() {
         d = Colors.green; 
        });
      }
      });
    }
}


class Summary extends StatelessWidget{
  final int score;
  Summary({Key key, @required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(

        body: new Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                    purple,
                                    lightBlue
                                  ])
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              new Text("Final Score: $score",
                style: new TextStyle(
                  color: Colors.white,
                                                  fontFamily: "Viga",
                                                  fontSize: 35.0),
                ),

              new Padding(padding: EdgeInsets.all(30.0)),

              new MaterialButton(
                color: orange,
                onPressed: (){
                  questionNumber = 0;
                  finalScore = 0;
                  Navigator.push(context, new MaterialPageRoute(builder: (context)=> new ListPage()));
                },
                child: new Text("Home",
                  style: new TextStyle(
                       color: Colors.white,
                                                  fontFamily: "Viga",
                                                  fontSize: 20.0),
                  ),),

            ],
          ),
        ),


      ),
    );
  }


}