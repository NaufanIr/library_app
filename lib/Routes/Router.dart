import 'package:get/get.dart';
import 'package:library_app/Bottom_navMenu/Books/AddBook.dart';
import 'package:library_app/Bottom_navMenu/Books/Borrow.dart';
import 'package:library_app/Bottom_navMenu/Books/UpdateBook.dart';
import 'package:library_app/Bottom_navMenu/Home/BookReturn.dart';
import 'package:library_app/Bottom_navMenu/Home/BorrowsList.dart';
import 'package:library_app/Bottom_navMenu/Home/Employee.dart';
import 'package:library_app/Bottom_navMenu/Home/ReturnList.dart';
import 'package:library_app/Bottom_navMenu/HomeNav.dart';
import 'package:library_app/Bottom_navMenu/Members/AddMember.dart';
import 'package:library_app/Bottom_navMenu/Members/UpdateMember.dart';
import 'package:library_app/Login.dart';
import 'package:library_app/SplashScreen.dart';
import 'package:library_app/Test.dart';

List<GetPage> get getRoutePages => _routePages;

List<GetPage> _routePages = [
  GetPage(name: Test.TAG, page: () => Test()),
  GetPage(name: SplashScreen.TAG, page: () => SplashScreen()),
  GetPage(name: Login.TAG, page: () => Login()),
  GetPage(name: '${HomeNav.TAG}/:index?', page: () => HomeNav()),
  GetPage(name: '${BookReturn.TAG}/:id', page: () => BookReturn()),
  GetPage(name: ReturnList.TAG, page: () => ReturnList()),
  GetPage(name: '${Borrow.TAG}/:id', page: () => Borrow()),
  GetPage(name: BorrowsList.TAG, page: () => BorrowsList()),
  GetPage(name: AddBook.TAG, page: () => AddBook()),
  GetPage(name: AddMember.TAG, page: () => AddMember()),
  GetPage(name: '${UpdateBook.TAG}/:id', page: () => UpdateBook()),
  GetPage(name: '${UpdateMember.TAG}/:id', page: () => UpdateMember()),
  GetPage(name: Employee.TAG, page: () => Employee()),
];