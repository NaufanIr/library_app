import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/API.dart';
import 'package:library_app/Bottom_navMenu/HomeNav.dart';
import 'package:library_app/Models/EmployeeData.dart';

class Login extends StatelessWidget {
  static final String TAG = '/Login';

  TextEditingController id = TextEditingController();
  TextEditingController pass = TextEditingController();

  var _visible = true.obs;

  String? nama, jabatan;


  @override
  Widget build(BuildContext context) {
    print("=====REFRESH=====");
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/Bg_Login.png"),
            fit: BoxFit.cover,
          ),
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
                Text(
                  "Welcome!",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 38,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30.0),

                //FORM LOGIN
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.fromLTRB(15, 40, 15, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TF USERNAME/ID
                      TextField(
                        controller: id,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "ID",
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.deepOrangeAccent),
                            borderRadius: BorderRadius.circular(23),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(23),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          filled: true,
                          fillColor: Colors.deepOrangeAccent,
                        ),
                      ),

                      SizedBox(height: 40),

                      //TF PASSWORD
                      Obx(
                        () => TextField(
                          controller: pass,
                          obscureText: _visible.value,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Password",
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepOrangeAccent),
                              borderRadius: BorderRadius.circular(23),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(23),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            filled: true,
                            fillColor: Colors.deepOrangeAccent,
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _visible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white),
                              onPressed: () {
                                _visible.value = !_visible.value;
                              },
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 70),

                      //BUTTON LOGIN
                      Center(
                        child: RaisedButton(
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          color: Colors.blueAccent,
                          padding: EdgeInsets.fromLTRB(100, 15, 100, 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () {
                            login(id: id.text, pass: pass.text).then(
                              (data) {
                                if (data.length == 0) {
                                  Get.rawSnackbar(
                                    messageText: Text(
                                      "Id/Password Salah",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 10,
                                    ),
                                    borderRadius: 5,
                                  );
                                } else {
                                  nama = data[0].nama;
                                  jabatan = data[0].jabatan;
                                  Get.offNamed('${HomeNav.TAG}/0?id=${id.text}&nama=$nama&jabatan=$jabatan');
                                }
                              },
                            );
                          },
                        ),
                      ),
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
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
