import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:library_app/Bottom_navMenu/Books/PdfApi.dart';
import 'package:library_app/Models/BooksData.dart';
import 'package:library_app/Models/MembersData.dart';
import 'package:library_app/Widgets/CardBook.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:library_app/Models/BorrowsData.dart';
//import 'package:toast/toast.dart';

class Borrow extends StatefulWidget {
  final String? idBuku;

  Borrow({required this.idBuku});

  @override
  _BorrowState createState() => _BorrowState();
}

class _BorrowState extends State<Borrow> {
//Text Editing Controller
  TextEditingController idAnggota = TextEditingController();
  TextEditingController tanggal = TextEditingController();

//Dialog Atribut Data
  var id;
  var judul;

//ID Generete
  String? idGenerator(
      {int? durasi, required String tgl, required String idAnggota}) {
    String date =
        tgl.substring(2, 4) + tgl.substring(5, 7) + tgl.substring(8, 10);
    String idMbr = idAnggota.substring(5, 8);
    if (durasi == 7) {
      return this.id = "A$date$idMbr";
    } else if (durasi == 14) {
      return this.id = "B$date$idMbr";
    } else if (durasi == 30) {
      return this.id = "C$date$idMbr";
    }
  }

//Set Tanggal --Form
  DateTime _today = DateTime.now();
  DateTime? _selectedDate;
  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null ? _selectedDate! : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.orangeAccent,
              onPrimary: Colors.white,
              surface: Colors.orangeAccent, //BG HEADER
              onSurface: Colors.white, //TEXT COLOR
            ),
            dialogBackgroundColor: Color(0xff5C549A),
          ),
          child: child!,
        );
      },
    );
    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      tanggal..text = DateFormat("yyyy-MM-dd").format(_selectedDate!);
    }
  }

//Tgl Kembali --Dialog
  String returnDate(
      {required int year,
      required int month,
      required int day,
      required int durasi}) {
    var date = DateTime(year, month, day).add(Duration(days: durasi));
    return DateFormat("d MMMM yyyy").format(date).toString();
  }

//Drop Down Durasi Pinjam --Form
  int? durasi;
  final List<int> durasiItem = [0, 7, 14, 30];

//Kartu Cetak
  void kartuPinjam() {
    showDialog(
      context: context,
      builder: (context) {
        return dialogKartuPinjam(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: AppBar(
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 15, bottom: 15),
            title: Text(
              "Pinjam Buku",
              style: TextStyle(
                  fontFamily: "Montserrat", fontSize: 18, color: Colors.white),
            ),
          ),
          backgroundColor: Color(0xff5C549A),
          automaticallyImplyLeading: false,
        ),
      ),
      body: FutureBuilder<List<BooksData>>(
        future: fetchBookById(id: widget.idBuku),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final data = snapshot.data![0];
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Buku Yang Dipinjam
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(3, 0, 3, 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Buku yang dipinjam",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 17),

                            //Card Buku
                            CardBook(
                              id: widget.idBuku,
                              judul: judul = data.judul,
                              pengarang: data.pengarang,
                              penerbit: data.penerbit,
                              tahun: data.tahun,
                            ),
                          ],
                        ),
                      ),
                    ),

                    //Peminjam
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(3, 10, 3, 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Peminjam",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 17),
                            TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: idAnggota,
                                decoration: InputDecoration(
                                  labelText: "ID Anggota",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              suggestionsCallback: (query) {
                                var suggestion;
                                suggestion = fetchMembers().then((val) {
                                  return val
                                      .where((element) =>
                                          element.nama!
                                              .toLowerCase()
                                              .contains(query) ||
                                          element.id!.startsWith(query))
                                      .toList();
                                });
                                return suggestion;
                              },
                              itemBuilder: (context, dynamic suggestion) {
                                final members = suggestion;
                                return ListTile(
                                  title: Text(
                                    "${members.id}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${members.nama}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                              onSuggestionSelected: (dynamic suggestion) {
                                idAnggota.text = suggestion.id;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    //Waktu
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(3, 10, 3, 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Waktu",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 17),

                            //TF DATE PICKER
                            TextField(
                              controller: tanggal,
                              decoration: InputDecoration(
                                labelText: "Tgl.Pinjam",
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.calendar_today,
                                      color: Colors.blue),
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                ),
                                suffix: GestureDetector(
                                  child: Text(
                                    "Today",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blue,
                                        fontFamily: "Montserrat"),
                                  ),
                                  onTap: () {
                                    setState(
                                      () {
                                        tanggal
                                          ..text = DateFormat('yyyy-MM-dd')
                                              .format(_today);
                                      },
                                    );
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //DROPDOWN MENU (DURASI PINJAM)
                            DropdownButtonFormField(
                              hint: Text("Durasi Pinjam"),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              value: this.durasi,
                              items: this.durasiItem.map((e) {
                                String? kalimat(int e) {
                                  if (e == 0) {
                                    return "Durasi Pinjam";
                                  } else if (e == 7) {
                                    return "$e Hari";
                                  } else if (e == 14) {
                                    return "$e Hari";
                                  } else if (e == 30) {
                                    return "$e Hari";
                                  }
                                }

                                return DropdownMenuItem(
                                  value: e,
                                  child: Text("${kalimat(e)}"),
                                );
                              }).toList(),
                              onChanged: (dynamic val) {
                                setState(
                                  () {
                                    durasi = val;
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    //Button Pinjam
                    RaisedButton(
                      child: Text(
                        "PINJAM",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 13,
                            color: Colors.white),
                      ),
                      color: Colors.blueAccent,
                      padding: EdgeInsets.fromLTRB(50, 13, 50, 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      onPressed: () {
                        if (this.idAnggota.text.isEmpty ||
                            this.tanggal.text.isEmpty ||
                            this.durasi == null ||
                            this.durasi == 0) {
                          Get.rawSnackbar(
                            messageText: Text(
                              "Data tidak valid",
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
                          idGenerator(
                            durasi: this.durasi,
                            tgl: this.tanggal.text,
                            idAnggota: this.idAnggota.text,
                          );
                          addBorrow(
                            id: this.id,
                            idAnggota: this.idAnggota.text,
                            idBuku: widget.idBuku,
                            tanggal: this.tanggal.text,
                            durasi: this.durasi.toString(),
                          ).then((value) {
                            kartuPinjam();
                            Get.rawSnackbar(
                              messageText: Text(
                                "Data peminjaman buku berhasil ditambahkan",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor:
                              Colors.blueAccent.withOpacity(0.93),
                              dismissDirection:
                              SnackDismissDirection.HORIZONTAL,
                              margin: EdgeInsets.symmetric(
                                vertical: 80,
                                horizontal: 15,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 10,
                              ),
                              borderRadius: 5,
                            );
                          });
                          // kartuPinjam();
                          // Get.rawSnackbar(
                          //   messageText: Text(
                          //     "Data peminjaman buku berhasil ditambahkan",
                          //     textAlign: TextAlign.center,
                          //     style: TextStyle(
                          //       fontSize: 13,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          //   backgroundColor:
                          //   Colors.blueAccent.withOpacity(0.93),
                          //   dismissDirection:
                          //   SnackDismissDirection.HORIZONTAL,
                          //   margin: EdgeInsets.symmetric(
                          //     vertical: 80,
                          //     horizontal: 15,
                          //   ),
                          //   padding: EdgeInsets.symmetric(
                          //     vertical: 12,
                          //     horizontal: 10,
                          //   ),
                          //   borderRadius: 5,
                          // );
                        }
                      },
                    ),
                    SizedBox(height: 20),

                    //Button Kembali
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          splashColor: Colors.black26,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(30, 13, 30, 13),
                            child: Text(
                              "KEMBALI",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 14,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Dialog dialogKartuPinjam(BuildContext context) {
    var tahun = int.parse(tanggal.text.toString().substring(0, 4));
    var bulan = int.parse(tanggal.text.toString().substring(5, 7));
    var hari = int.parse(tanggal.text.toString().substring(8, 10));
    var tglKembali =
        returnDate(year: tahun, month: bulan, day: hari, durasi: this.durasi!);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            //DETAILS
            Container(
              padding: EdgeInsets.fromLTRB(20, 100, 20, 15),
              margin: EdgeInsets.only(top: 35),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(17),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //HEADER
                  Text(
                    "Kartu Peminjaman",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      color: Color(0xff5C549A),
                    ),
                  ),
                  SizedBox(height: 30),

                  //DETAILS
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //ID ANGGOTA
                        Row(
                          children: [
                            Text(
                              "ID Anggota : ",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 10.5,
                                color: Color(0xff5C549A),
                              ),
                            ),
                            Text(
                              idAnggota.text,
                              style: TextStyle(
                                fontSize: 10.5,
                                color: Color(0xff5C549A),
                              ),
                            ),
                          ],
                        ),

                        //JUDUL BUKU
                        Row(
                          children: [
                            Text(
                              "Buku : ",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 10.5,
                                color: Color(0xff5C549A),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                judul,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: Color(0xff5C549A),
                                ),
                              ),
                            ),
                          ],
                        ),

                        //DURASI PINJAM
                        Row(
                          children: [
                            Text(
                              "Durasi Pinjam : ",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 10.5,
                                color: Color(0xff5C549A),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "$durasi Hari",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: Color(0xff5C549A),
                                ),
                              ),
                            ),
                          ],
                        ),

                        //TGL.KEMBALI
                        Row(
                          children: [
                            Text(
                              "Tgl.Kembali : ",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 10.5,
                                color: Color(0xff5C549A),
                              ),
                            ),
                            Text(
                              "$tglKembali",
                              style: TextStyle(
                                fontSize: 10.5,
                                color: Color(0xff5C549A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  //ID KARTU PEMINJAMAN
                  Text(
                    "ID : ${this.id}",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 12,
                      color: Color(0xff5C549A),
                    ),
                  ),

                  //QR CODE
                  QrImage(
                    size: 110,
                    data: this.id, //qrData(),
                  ),
                  SizedBox(height: 10),

                  //BUTTON CETAK
                  RaisedButton(
                    splashColor: Colors.black54,
                    child: Text(
                      "CETAK",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 12,
                        color: Color(0xff5C549A),
                      ),
                    ),
                    color: Colors.orange[300],
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () async {
                      PdfApi.cetakKartu(
                        idAnggota: idAnggota.text,
                        judul: this.judul,
                        durasi: this.durasi.toString(),
                        tgl: tglKembali,
                        id: this.id,
                      );
                    },
                  ),
                ],
              ),
            ),
            //Logo/Avatar
            Positioned(
              top: 0,
              left: 50,
              right: 50,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  "images/logo.svg",
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
