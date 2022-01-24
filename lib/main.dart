import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_app/Bottom_navMenu/HomeNav.dart';
import 'package:library_app/Routes/Router.dart';
import 'package:library_app/SplashScreen.dart';
import 'package:get/get.dart';
import 'package:library_app/Test.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Library App",
      getPages: getRoutePages,
      //initialRoute: Test.TAG,
      //initialRoute: SplashScreen.TAG,
      initialRoute: '${HomeNav.TAG}/0',
      debugShowCheckedModeBanner: false,
    );
  }
}

//flutter run --release

//DATABASE
//nama database = naufanPerpustakaan
//Username : id16976663_root
//Pass : Ic*ljuCLUJPr3HAR
//https://databases-auth.000webhost.com/sql.php?server=1&db=id16976663_perpustakaan&table=petugas&pos=0

//namaDB : id16976663_naufanperpustakaan
//userDB : id16976663_id16976663_root

//FOLDER APK : C:\Users\swift 3\AndroidStudioProjects\Flutter\library_app\android\app\release