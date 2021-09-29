import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/API.dart';
import 'package:library_app/Bottom_navMenu/HomeNav.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController id = TextEditingController();
  TextEditingController pass = TextEditingController();

  String? user;
  Future _login() async {
    final response = await http
        .post(Uri.parse("${API.login}"), body: {"id": id.text, "password": pass.text});
    var userAccount = jsonDecode(response.body);
    if (userAccount.length == 0) {
      _showSnackBar();
      print("Gagal Masuk");
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeNav()));
    }
    user = userAccount[0]['nama'];
  }

//SNACKBAR
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _showSnackBar() {
    final snackbar = SnackBar(
        content: Text("Id/Password Salah", textAlign: TextAlign.center),
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 5));
    _scaffoldKey.currentState!.showSnackBar(snackbar);
  }

  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/Bg_Login.png"), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 60, 20, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  height: MediaQuery.of(context).size.height / 4,
                  child: SvgPicture.asset(
                    "images/logo.svg",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 10),
                //TEXT WELCOME
                Text("Welcome!",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 38,
                        color: Colors.white)),
                SizedBox(height: 30.0),
                //FORM LOGIN
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.fromLTRB(15, 40, 15, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TF USERNAME/ID
                      TextField(
                        controller: id,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "ID",
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepOrangeAccent),
                                borderRadius: BorderRadius.circular(23)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(23)),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            filled: true,
                            fillColor: Colors.deepOrangeAccent),
                        cursorColor: Colors.white,
                      ),
                      SizedBox(
                        height: 40,
                      ),

                      //TF PASSWORD
                      TextField(
                        controller: pass,
                        obscureText: _visible,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Password",
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepOrangeAccent),
                                borderRadius: BorderRadius.circular(23)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(23)),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(
                                    _visible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _visible = !_visible;
                                  });
                                }),
                            filled: true,
                            fillColor: Colors.deepOrangeAccent),
                        cursorColor: Colors.white,
                      ),

                      SizedBox(
                        height: 70,
                      ),

                      //BUTTON LOGIN
                      Center(
                        child: RaisedButton(
                          child: Text("LOGIN",
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 20,
                                  color: Colors.white)),
                          color: Colors.blueAccent,
                          padding: EdgeInsets.fromLTRB(100, 15, 100, 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            _login();
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 90),
                //ALL RIGHT RESERVED
                Text(
                  "All Right Reserved",
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 10,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
