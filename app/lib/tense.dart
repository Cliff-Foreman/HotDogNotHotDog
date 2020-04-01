import 'dart:convert';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Tense extends StatefulWidget {
  @override
  _TenseState createState() => _TenseState();
}

class _TenseState extends State<Tense> {
  File _image;
  String _result;
  var _out = false;
  var _opo = true;
  var _options = "Tap the Hotdog";
  bool _isLoading;

  Future _getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      _result = "Loading...";
      _isLoading = true;
    });

    var output = await Tflite.runModelOnImage(
        path: _image.path,
        numResults: 2,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.5);

    print(output);
    _isLoading = false;

    setState(() {
      _result = output[0]["label"];
      _out = false;
    });
  }

  Future _takeImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
      _result = "Loading...";
      _isLoading = true;
    });

    var output = await Tflite.runModelOnImage(
        path: _image.path,
        numResults: 2,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.5);

    print(output);
    _isLoading = false;

    setState(() {
      _result = output[0]["label"];
      _out = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
    _isLoading = false;
  }

  _toggle() async {
    if (_out == false) {
      setState(() {
        _out = true;
        _opo = false;
        _result = null;
      });

      await new Future.delayed(const Duration(milliseconds: 1000));

      setState(() {
        _opo = true;
        _options = "Select an option";
      });
    } else {
      setState(() {
        _out = false;
        _opo = false;
      });

      await new Future.delayed(const Duration(milliseconds: 1000));

      setState(() {
        _opo = true;
        _options = "Tap the Hotdog";
      });
    }
  }

  Widget displayNoImage(double Top, double Left) {
    if (_image == null) {
      return Stack(
        children: <Widget>[
          AnimatedPositioned(
            child: FloatingActionButton(
              onPressed: _takeImage,
              backgroundColor: Colors.green,
              child: Icon(Icons.camera_alt),
            ),
            duration: Duration(milliseconds: 200),
            left: _out ? Left + 100 : Left,
            top: _out ? Top - 80 : Top,
          ),
          AnimatedPositioned(
            child: FloatingActionButton(
              onPressed: _getImage,
              heroTag: null,
              backgroundColor: Color.fromRGBO(0xe3, 0xe0, 0x0a, 1),
              child: Icon(Icons.folder_open),
            ),
            duration: Duration(milliseconds: 200),
            left: _out ? Left - 100 : Left,
            top: _out ? Top - 80 : Top,
          ),
          AnimatedPositioned(
            child: FloatingActionButton(
              onPressed: _toggle,
              heroTag: null,
              backgroundColor: Colors.red,
              child: Icon(Icons.cancel),
            ),
            duration: Duration(milliseconds: 200),
            left: Left,
            top: _out ? Top + 110 : Top,
          ),
          AnimatedPositioned(
            child: FloatingActionButton(
              onPressed: _toggle,
              heroTag: null,
              child: Container(
                margin: EdgeInsets.only(right: 2),
                child: Image(
                  image: AssetImage("assets/hotdogIco.png"),
                  width: 50,
                ),
              ),
            ),
            duration: Duration(milliseconds: 1),
            left: Left,
            top: Top,
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          AnimatedPositioned(
            child: FloatingActionButton(
              onPressed: _toggle,
              backgroundColor: Colors.red,
              child: Icon(Icons.cancel),
            ),
            duration: Duration(milliseconds: 200),
            left: _out ? 205 : 315,
            top: 800,
          ),
          AnimatedPositioned(
            child: FloatingActionButton(
              onPressed: _takeImage,
              backgroundColor: Colors.green,
              child: Icon(Icons.camera_alt),
            ),
            duration: Duration(milliseconds: 200),
            left: 315,
            top: _out ? 690 : 800,
          ),
          AnimatedPositioned(
            child: FloatingActionButton(
              onPressed: _getImage,
              backgroundColor: Color.fromRGBO(0xe3, 0xe0, 0x0a, 1),
              child: Icon(Icons.folder_open),
            ),
            duration: Duration(milliseconds: 200),
            left: _out ? 225 : 315,
            top: _out ? 709.5 : 800,
          ),
          AnimatedPositioned(
            child: FloatingActionButton(
              onPressed: _toggle,
              child: Image(
                image: AssetImage("assets/hotdogIco.png"),
                width: 50,
              ),
            ),
            duration: Duration(milliseconds: 2),
            left: 315,
            top: 800,
          ),
        ],
      );
    }
  }

  Widget textDisplay() {
    if (_image == null) {
      return Text(
        _options,
        style: TextStyle(fontSize: 36, color: Colors.white),
      );
    } else {
      return Column(
        children: <Widget>[
          Container(child: Image.file(_image), width: 600, height: 400),
        ],
      );
    }
  }

  Widget myResult() {
    if (_result == null || _image == null) {
      return Text("");
    }

    if (!_result.contains("N")) {
      return Stack(
        children: <Widget>[
          Center(
            child: Container(
              height: 125,
              decoration: new BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              margin: EdgeInsets.only(top: 235),
            ),
          ),
          Container(
            height: 110,
            decoration: new BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(top: 510),
          ),
          Container(
            height: 100,
            decoration: new BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(top: 515),
          ),
          Container(
            child: Icon(
              Icons.check,
              size: 60,
            ),
            margin: EdgeInsets.only(top: 510, left: 175),
          ),
          Container(
            width: 550,
            height: 115,
            color: Colors.green,
            margin: EdgeInsets.only(top: 560),
          ),
          Container(
            width: 400,
            height: 75,
            color: Colors.black,
            margin: EdgeInsets.only(top: 580, left: 7),
          ),
          Container(
            width: 375,
            height: 50,
            color: Colors.green[400],
            margin: EdgeInsets.only(top: 592, left: 18),
            child: Container(
              child: Text(
                "Hot Dog",
                style: TextStyle(fontSize: 24),
              ),
              margin: EdgeInsets.only(top: 7.5, left: 140),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          Center(
            child: Container(
              height: 125,
              decoration: new BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              margin: EdgeInsets.only(top: 235),
            ),
          ),
          Container(
            height: 110,
            decoration: new BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(top: 510),
          ),
          Container(
            height: 100,
            decoration: new BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(top: 515),
          ),
          Container(
            child: Icon(
              Icons.check,
              size: 60,
            ),
            margin: EdgeInsets.only(top: 510, left: 175),
          ),
          Container(
            width: 550,
            height: 115,
            color: Colors.red,
            margin: EdgeInsets.only(top: 560),
          ),
          Container(
            width: 400,
            height: 75,
            color: Colors.black,
            margin: EdgeInsets.only(top: 580, left: 7),
          ),
          Container(
            width: 375,
            height: 50,
            color: Colors.red[400],
            margin: EdgeInsets.only(top: 592, left: 18),
            child: Container(
              child: Text(
                "Not Hot Dog",
                style: TextStyle(fontSize: 24),
              ),
              margin: EdgeInsets.only(top: 7.5, left: 120),
            ),
          ),
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0x6b, 0x6b, 0x6b, 1),
      body: Stack(
        children: <Widget>[
          AnimatedOpacity(
            opacity: _image == null ? (_opo ? 1 : 0) : 1,
            duration: Duration(milliseconds: 600),
            child: Container(
              child: textDisplay(),
              margin: EdgeInsets.only(left: _image == null ? 85 : 0, top: 75),
            ),
          ),
          displayNoImage(400, 180),
          myResult(),
        ],
      ),
    );
  }
}
