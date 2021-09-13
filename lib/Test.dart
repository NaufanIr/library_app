import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:library_app/Bottom_navMenu/HomeNav.dart';
import 'package:library_app/Bottom_navMenu/Members/AddMember.dart';
import 'package:library_app/Models/BorrowsData.dart';
import 'package:library_app/Models/MembersData.dart';
import 'package:library_app/Widgets/CardBorrow.dart';
import 'package:library_app/Widgets/CardMember.dart';
import 'Bottom_navMenu/Books/AddBook.dart';
import 'Bottom_navMenu/Books/Borrow.dart';
import 'Bottom_navMenu/Home/BookReturn.dart';
import 'Bottom_navMenu/Home/BorrowsList.dart';
import 'Search.dart';
import 'Widgets/CardBook.dart';

class test extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,//Color(0x1f5C549A),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: AppBar(
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 15, bottom: 15),
            title: Text(
              "Test",
              style: TextStyle(
                  fontFamily: "Montserrat", fontSize: 18, color: Colors.white),
            ),
          ),
          backgroundColor: Color(0xff5C549A),
          automaticallyImplyLeading: false,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CardMember(
            id: "17111744",
            nama: "Ahmad Saeful",
            kelas: "10IPA2",
            telp: "085783514138",
            alamat: "Perum.Pondok Ungu Permai Bl C-3/16,Lakiabang Tengah",
            gender: "L",
            onTap: (){},
          ),
          CardBook(
            id: "KP12007",
            judul: "Bahasa Mandarin",
            pengarang: "Lee Chong Wei",
            penerbit: "Alibaba",
            tahun: "2014",
            jumlah: 4,
            onTap: () {
              print("Tap");
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => homeNav()),
              // );
            },
          ),
          CardBorrow(
            id: "A210118744",
            judul: "Bahasa Arab",
            peminjam: "Ahmad Saeful",
            tanggal: "2021-07-29",
            durasi: "14",
          ),
        ],
      ),
    );
  }
}