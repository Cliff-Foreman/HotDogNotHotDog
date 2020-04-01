import 'dart:io';
import 'package:flutter/material.dart';

import './tense.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {"/tense": (context) => Tense()},
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _visible = false;
  var _toggle = false;

  @override
  void initState() {
    super.initState();
    sleepChange();
    loaderChange();
  }

  sleepChange() async {
    await new Future.delayed(const Duration(seconds: 3));
    setState(() {
      _visible = true;
    });
  }

  loaderChange() async {
    await new Future.delayed(const Duration(seconds: 5));
    setState(() {
      _toggle = true;
    });
  }

  Widget loader() {
    return (AnimatedOpacity(
      opacity: _toggle ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: Container(
          margin: EdgeInsets.only(left: 50, top: 200),
          child: Text(
            "Click to start...",
            style: TextStyle(fontSize: 30),
          )),
    ));
  }

  nav() {
    Navigator.of(context).pushNamed("/tense");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: nav,
        child: Stack(
          children: <Widget>[
            AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 180, left: 60),
                      child: Image(
                        fit: BoxFit.fitWidth,
                        width: 300,
                        height: 300,
                        image: AssetImage("assets/logo.png"),
                      ),
                    ),
                    Container(
                      child: loader(),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
