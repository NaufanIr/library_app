import 'dart:async';
import 'package:flutter/material.dart';
import 'package:library_app/Login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 5);
    return Timer(duration, route);
  }

  route(){
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => Login()
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6A639F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/bookshelf.png",
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width / 2
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100),
              child: LinearProgressIndicator(
                backgroundColor: Colors.orange[300],
                valueColor: AlwaysStoppedAnimation(Colors.blue[400]),
              ),
            )
          ],
        ),
      ),
    );
  }
}