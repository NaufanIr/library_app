import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:library_app/API.dart';
import 'package:library_app/Bottom_navMenu/Home/BookReturn.dart';
import 'package:library_app/Bottom_navMenu/Home/BorrowsList.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:library_app/Login.dart';
import 'package:library_app/Models/BooksData.dart';
import 'package:library_app/Models/BorrowsData.dart';
import 'package:library_app/Models/MembersData.dart';
import 'package:library_app/Widgets/CardBorrow.dart';
//import 'package:toast/toast.dart';
import 'ReturnList.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;
  List<T> dotIndex<T>(Function handler) {
    List<T> dots = [];
    for (var i = 0; i < 5; i++) {
      dots.add(handler(i));
    }
    return dots;
  }

//SCAN QRCODE LOGIC
  String qrData = "";
  Future scanQRCode() async {
    qrData = await FlutterBarcodeScanner.scanBarcode(
        "#ff6A639F", "Cancel", true, ScanMode.QR);
    fetchBorrowById(id: qrData).then((data) {
      if(data.length == 0){
        print(data.length);
        Get.rawSnackbar(
          messageText: Text(
            "Data tidak ditemukan",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          snackPosition: SnackPosition.TOP,
          dismissDirection: SnackDismissDirection.HORIZONTAL,
          backgroundColor: Colors.redAccent.withOpacity(0.93),
          margin: EdgeInsets.symmetric(
            vertical: 54,
            horizontal: 8,
          ),
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10,
          ),
          borderRadius: 12,
        );
      }else{
        var id = data[0].id;
        var tanggal = data[0].tanggal;
        var durasi = data[0].durasi;
        var tahun = int.parse(tanggal.toString().substring(0, 4));
        var bulan = int.parse(tanggal.toString().substring(5, 7));
        var hari = int.parse(tanggal.toString().substring(8, 10));
        var duration = int.parse(durasi.toString().substring(0, 2));
        int denda = CardBorrow.returnCountDown(
            year: tahun, month: bulan, day: hari, durasi: duration);
        setState(
              () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return bookReturn(id: id, denda: denda,);
                },
              ),
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x1f5C549A),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          elevation: 5,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 60, bottom: 13),
            title: Text(
              "Home",
              style: TextStyle(
                  fontFamily: "Montserrat", fontSize: 18, color: Colors.white),
            ),
          ),
          backgroundColor: Color(0xff5C549A),
          // actions: [
          //   Center(
          //     child: Container(
          //       margin: EdgeInsets.only(right: 12),
          //       child: Text(
          //         "Naufan Ir - Staff",
          //         style: TextStyle(
          //             fontFamily: "Montserrat",
          //             fontSize: 13,
          //             color: Colors.white),
          //       ),
          //     ),
          //   ),
          // ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          //JADWAL
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 20, bottom: 12, left: 5, right: 5),
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                image: DecorationImage(
                    image: AssetImage("images/Bg_Schedule.png"),
                    fit: BoxFit.cover),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Daftar Peminjaman",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 16,
                                color: Colors.white),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.orange[300],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 15,
                                  offset: Offset(1, 3),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                splashColor: Colors.blue[400],
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  child: Text(
                                    "More",
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 13,
                                      color: Color(0xff6A639F),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return BorrowsList();
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),

                    //CARD PINJAM BUKU
                    FutureBuilder<List<BorrowsData>>(
                      future: fetchBorrows(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 215,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return CarouselSlider.builder(
                            options: CarouselOptions(
                              height: 215,
                              viewportFraction: 1,
                              enableInfiniteScroll: false,
                              autoPlay: true,
                              pageSnapping: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int index, _) {
                              final data = snapshot.data![index];
                              var tahun = int.parse(
                                  data.tanggal!.substring(0, 4));
                              var bulan = int.parse(
                                  data.tanggal!.substring(5, 7));
                              var hari = int.parse(
                                  data.tanggal!.substring(8, 10));
                              var duration = int.parse(data.durasi!);
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 7,
                                ),
                                child: CardBorrow(
                                  id: data.id,
                                  judul: data.judul,
                                  peminjam: data.nama,
                                  tanggal: data.tanggal,
                                  durasi: data.durasi,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          bool denda = CardBorrow.returnCountDown(
                                            year: tahun,
                                            month: bulan,
                                            day: hari,
                                            durasi: duration,
                                          ).isNegative;
                                          return bookReturn(
                                            id: data.id,
                                            denda: CardBorrow.returnCountDown(
                                              year: tahun,
                                              month: bulan,
                                              day: hari,
                                              durasi: duration,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    SizedBox(height: 5),

                    //DOT INDICATOR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: dotIndex<Widget>((index) {
                        if (_currentIndex == index) {
                          return Container(
                            width: 15,
                            height: 4,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.orange[300],
                            ),
                          );
                        } else {
                          return Container(
                            width: 4,
                            height: 4,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white54,
                            ),
                          );
                        }
                      })
                    ),
                  ],
                ),
              ),
            ),
          ),

          //QR CODE SCANNER
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
              width: MediaQuery.of(context).size.width,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.blue[400],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 7,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.orange[400],
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12, 5, 20, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Scann Barcode",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 14,
                              color: Colors.white), //Color(0xff5C549A)),
                        ),
                        SvgPicture.asset(
                          "images/qrCode.svg",
                          height: 30,
                          width: 30,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    scanQRCode();
                  },
                ),
              ),
            ),
          ),

          //INFORMASI
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 10, left: 5, right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                    image: AssetImage("images/Bg_Schedule.png"),
                    fit: BoxFit.cover),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 7,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(7, 13, 7, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Informasi",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),

                    //INFORMASI JUMLAH MEMBER
                    FutureBuilder<List<MembersData>>(
                      future: fetchMembers(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return infoCard(
                            context: context,
                            pict: "images/teamwork.png",
                            caption: "JUMLAH MEMBER : ",
                            total: snapshot.data!.length,
                          );
                        }
                      },
                    ),

                    //INFORMASI JUMLAH BUKU
                    FutureBuilder<List<BooksData>>(
                      future: fetchBooks(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return infoCard(
                            context: context,
                            pict: "images/books.png",
                            caption: "JUMLAH JUDUL BUKU : ",
                            total: snapshot.data!.length,
                          );
                        }
                      },
                    ),

                    //INFORMASI JUMLAH BUKU YANG SEDANG DI PINJAM
                    FutureBuilder<List<BorrowsData>>(
                      future: fetchBorrows(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return infoCard(
                            context: context,
                            pict: "images/invoice.png",
                            caption: "BUKU YANG SEDANG DI PINJAM : ",
                            total: snapshot.data!.length,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 80,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Flexible(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 32, 20, 0),
                    width: MediaQuery.of(context).size.width,
                    //color: Colors.deepPurple,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/Bg_Login.png"),
                          fit: BoxFit.fill),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_circle,
                            size: 85, color: Colors.white),
                        SizedBox(height: 15),
                        Text(
                          "PA15118258 - NAUFAN IRFANDA",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 11,
                              color: Colors.white),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Admin",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 11,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 10,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.orange[300],
                child: ListView(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 90),
                  children: [
                    // menuDrawer(
                    //   caption: "EDIT PROFILE",
                    //   onTap: () {},
                    // ),
                    // menuDrawer(
                    //   caption: "EDIT PASSWORD",
                    //   onTap: () {},
                    // ),
                    // menuDrawer(
                    //   caption: "PEGAWAI",
                    //   onTap: () {},
                    // ),
                    menuDrawer(
                      caption: "DAFTAR PENGEMBALIAN BUKU",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ReturnList();
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    RaisedButton(
                      splashColor: Colors.black54,
                      child: Text(
                        "LOG OUT",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 13,
                            color: Colors.white),
                      ),
                      color: Colors.redAccent,
                      padding: EdgeInsets.fromLTRB(75, 10, 75, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Material menuDrawer({required String caption, Function? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.blue[500],
        onTap: onTap as void Function()?,
        child: Container(
          padding: EdgeInsets.only(top: 30, bottom: 30),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey),
            ),
          ),
          child: Center(
            child: Text(
              "$caption",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container infoCard({
    required BuildContext context,
    required String pict,
    required String caption,
    required int? total,
    //@required Color bgColor,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: 65,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.orange[300], //Colors.red[300],
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Row(
          children: [
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("$pict"), fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 25),
            Expanded(
              child: Text(
                "$caption ${total == null ? "0" : total} ${caption.toString().contains("BUKU") ? "BUKU" : "ORANG"}",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 11,
                  color: Color(0xff6A639F),
                ),
              ), //Colors.blue[700])),
            ),
          ],
        ),
      ),
    );
  }
}
