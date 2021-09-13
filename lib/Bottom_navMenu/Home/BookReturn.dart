import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:library_app/ErrorPage.dart';
import 'package:library_app/Models/BorrowsData.dart';
import 'package:library_app/Models/ReturnsData.dart';
import 'package:library_app/Widgets/CardBorrow.dart';
import 'package:toast/toast.dart';
import 'package:lottie/lottie.dart';

class bookReturn extends StatefulWidget {
  var id;
  int denda;

  bookReturn({@required this.id, this.denda});

  @override
  _bookReturnState createState() => _bookReturnState();
}

class _bookReturnState extends State<bookReturn> {
//TextEditingController
  TextEditingController tgl = TextEditingController();
  TextEditingController keterlambatan = TextEditingController();
  TextEditingController ket = TextEditingController(text: "");

//Date Picker
  DateTime _today = DateTime.now();
  DateTime _selectedDate;
  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
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
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      tgl..text = DateFormat("yyyy-MM-dd").format(_selectedDate);
    }
  }

//Switch Denda
  bool isDenda = false;
  int totalDenda;
  Widget showFormDenda(bool denda) {
    if (denda == false) {
      return Container();
    } else if (denda == true) {
      return formDenda();
    }
  }

  int cetakDenda(int penalty, int kategori) {
    if (penalty < 0) {
      penalty = penalty * -1;
    } else {
      penalty = 0;
    }
    return this.totalDenda = (penalty * 1000) + kategori;
  }

//DropDown Buku Rusak
  int _selectedRusak = 0;
  final List<int> rusak = [0, 25000, 75000, 200000];

//SNACKBAR
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _showSnackBar() {
    final snackbar = SnackBar(
        content: Text("Buku telah dikembalikan", textAlign: TextAlign.center),
        backgroundColor: Colors.green[400],
        duration: Duration(seconds: 5));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

//Selesai Pinjam Logic
  void selesaiPinjam() {
    showDialog(
      context: context,
      builder: (context) {
        return confirmDialog(context);
      },
    );
  }

  isError() {
    setState(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ErrorPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Pengembalian Buku",
            style: TextStyle(
                fontFamily: "Montserrat", fontSize: 18, color: Colors.white),
          ),
          backgroundColor: Color(0xff5C549A),
        ),
      ),
      body: FutureBuilder<List<BorrowsData>>(
        future: fetchBorrowById(id: widget.id),
        builder: (context, snapshot) {
          try {
            final data = snapshot.data[0];
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 30),
                child: Column(
                  children: [
                    //Buku Yang Dipinjam
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 17),
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Buku yang dikembalikan",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500),
                          ),

                          //Card Transaksi Pengembalian Buku
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 17),
                            child: CardBorrow(
                              id: data.id,
                              judul: data.judul,
                              peminjam: data.nama,
                              tanggal: data.tanggal,
                              durasi: data.durasi,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Waktu
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 17, left: 3, right: 3),
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
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 17),
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
                            SizedBox(
                              height: 17,
                            ),

                            //TF DATE PICKER
                            TextField(
                              controller: tgl,
                              keyboardType:
                                  TextInputType.numberWithOptions(signed: true),
                              decoration: InputDecoration(
                                labelText: "Tgl.Pengembalian",
                                hintText: "YYYY-MM-DD",
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
                                        tgl
                                          ..text = DateFormat('yyyy-MM-dd')
                                              .format(_today);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //Switch Denda
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 5, left: 3, right: 3),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Denda",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500),
                          ),
                          Switch(
                            value: this.isDenda =
                                widget.denda.isNegative ? !isDenda : isDenda,
                            onChanged: (val) {
                              setState(
                                () {
                                  isDenda = val;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    //Form Denda
                    Container(
                      child: showFormDenda(isDenda),
                    ),
                    SizedBox(
                      height: 50,
                    ),

                    //Button Selesai
                    RaisedButton(
                      child: Text(
                        "KEMBALIKAN BUKU",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 13,
                            color: Colors.white),
                      ),
                      color: Colors.blueAccent,
                      padding: EdgeInsets.fromLTRB(30, 13, 30, 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      onPressed: () {
                        if (tgl.text.isEmpty) {
                          Toast.show(
                            "Masukan format waktu yang valid",
                            context,
                            duration: 1,
                            backgroundColor:
                                Colors.redAccent.shade700.withOpacity(0.7),
                            gravity: Toast.CENTER,
                          );
                        } else {
                          selesaiPinjam();
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    //Button Batal
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
                              "BATAL",
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
          } catch (e) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
            //isError();
          }
        },
      ),
    );
  }

  Container formDenda() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(3),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          //DROPDOWN JENIS DENDA
          DropdownButtonFormField(
            hint: Text("Rusak/Cacat"),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            value: this._selectedRusak,
            items: this.rusak.map((e) {
              String kalimat(int e) {
                if (e == 25000) {
                  return "Rp.${e.toString()} => Rusak Ringan";
                } else if (e == 75000) {
                  return "Rp.${e.toString()} => Rusak Sedang";
                } else if (e == 200000) {
                  return "Rp.${e.toString()} => Rusak Berat/Hilang";
                } else {
                  return "None";
                }
              }
              return DropdownMenuItem(
                value: e,
                child: Text("${kalimat(e)}"),
              );
            }).toList(),
            onChanged: (val) {
              setState(
                () {
                  _selectedRusak = val;
                },
              );
            },
          ),
          SizedBox(height: 15),

          //TF KETERANGAN DENDA
          TextField(
            controller: ket,
            maxLines: 7,
            decoration: InputDecoration(
              hintText: "Keterangan",
              labelText: "Keterangan",
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 25),

          Text(
            "DENDA : ${NumberFormat.currency(
              locale: 'id',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(cetakDenda(widget.denda, _selectedRusak))}",
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Montserrat",
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Dialog confirmDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 380,
        padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 10),
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //CONFIRM ICON
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              radius: 50,
              child: Lottie.network(
                  "https://assets7.lottiefiles.com/packages/lf20_HhOOsG.json"),
            ),
            //HEADER
            Text(
              "Konfirmasi",
              style: TextStyle(
                  fontFamily: "Montserrat", fontSize: 23, color: Colors.black),
            ),
            //MESSAGES
            Text(
              "Apakah anda ingin mengembalikan buku ini? Pastikan anda "
              "telah memeriksa kondisi buku sebelum buku dikembalikan.",
              style: TextStyle(height: 1.5),
            ),
            //BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  child:
                      Text("Konfirmasi", style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    addReturn(
                      idPeminjaman: widget.id,
                      tanggal: tgl.text,
                      denda: totalDenda.toString(),
                      ket: ket.text,
                    ).then((e) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Toast.show("Buku telah dikembalikan", context);
                    });
                  },
                ),
                SizedBox(width: 20),
                GestureDetector(
                  child: Text("Batal", style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

//https://assets7.lottiefiles.com/packages/lf20_HhOOsG.json
