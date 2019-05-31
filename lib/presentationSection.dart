import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ponder_nlc/Colors.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

import 'package:ponder_nlc/main.dart';
import 'package:ponder_nlc/settings.dart';

class PresentationSection extends StatefulWidget {
  @override
  _PresentationSectionState createState() => _PresentationSectionState();
}

class _PresentationSectionState extends State<PresentationSection> {

  static FirebaseUser currentUser;
  
  File _imageFile;
  bool _uploaded = false;

  StorageReference _reference = FirebaseStorage.instance.ref().child(user.email);
  String _downloadUrl;

  Future getImage (bool isCamera) async {
    File image;
    if (isCamera) {
      image = await ImagePicker.pickVideo(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickVideo(source: ImageSource.gallery);
    }
    setState(() {
      _imageFile = image;
    });
  }


  Future uploadImage() async{
    StorageUploadTask uploadTask = _reference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      _uploaded = true;
    });
    _uploaded == false ? CircularProgressIndicator() : _showDialog(); 
  }

  Future downloadImage() async {
    String downloadAddress = await _reference.getDownloadURL();
    setState(() {
      _downloadUrl = downloadAddress;
    });
  }

  @override
  void initState() {
    
    super.initState();
    
  }


  
  @override
  Widget build(BuildContext context) {

    
    
        return Scaffold(
          backgroundColor: colorVal? dark : Colors.white,
          body: SingleChildScrollView(
            child: Center(
                child:Column(
                children: <Widget>[
                  RaisedButton(
                    color: green,
                    shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
                    child: Text("Camera",style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      getImage(true);
                    }, 
                  ),
                  SizedBox(height: 10.0,),
                  RaisedButton(
                    color: red,
                    shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
                    child: Text('Gallery',style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      getImage(false);
                    },
                  ),
                  _imageFile == null 
                  ? Container(child: Text('1.Select or Record Video\n2.Upload the video\n3.Wait 2-3 buisiness days for feedback\nVideos will be deleted 1 week after submission',style: TextStyle(color: colorVal ? Colors.white : dark,fontSize: 20.0,),textAlign: TextAlign.center,
                  ),)
                  : Image.file(
                    _imageFile,
                    height: 300.0, 
                    width: 300.0,
                    ),
                   _imageFile == null ? Container() : RaisedButton(
                     color: lightBlue,
                     shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
                     child: Text("Upload to Storage",style: TextStyle(color: Colors.white)),
                     onPressed: () {
                       uploadImage();
                     },
                   ),
                ],
              ),
            ),
          ),
        );
  }
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
          title: new Text(
            "Progress",
            style: TextStyle(color: dark),
          ),
          content: Text(
                "Done",
                style: TextStyle(color: dark)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Done",
                style: TextStyle(color: dark),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}