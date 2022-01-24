import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'Models/BooksData.dart';
import 'Models/BorrowsData.dart';
import 'Widgets/CardBook.dart';
import 'Widgets/CardBorrow.dart';

class Test extends StatefulWidget {
  static final String TAG = '/Test';

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  int? denda;
  var isDenda;

  // Future GetDenda() async {
  //   denda = await fetchBorrowById(id: "A210802643").then(
  //         (data) => CardBorrow.returnCountDown(
  //       year: int.parse(data[0].tanggal!.substring(0, 4)),
  //       month: int.parse(data[0].tanggal!.substring(5, 7)),
  //       day: int.parse(data[0].tanggal!.substring(8, 10)),
  //       durasi: int.parse(data[0].durasi!),
  //     ),
  //   );
  // }

  TextEditingController tgl = TextEditingController();

  TextEditingController keterlambatan = TextEditingController();

  TextEditingController ket = TextEditingController(text: "");

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
      tgl..text = DateFormat("yyyy-MM-dd").format(_selectedDate!);
    }
  }

  Widget? showFormDenda(bool denda) {
    if (denda == false) {
      return Container();
    } else if (denda == true) {
      return formDenda();
    }
  }

  int? totalDenda;

  int cetakDenda(int keterlambatan, int kategori) {
    if (keterlambatan < 0) {
      keterlambatan = keterlambatan * -1;
    } else {
      keterlambatan = 0;
    }
    return this.totalDenda = (keterlambatan * 1000) + kategori;
  }

  var _selectedRusak = 0.obs;

  final List<int> rusak = [0, 25000, 75000, 200000];


  @override
  Widget build(BuildContext context) {
    //isDenda = denda!.isNegative ? true.obs : false.obs;
    print("=======REFRESH========");
    //GetDenda();
    //print("---Denda = $denda---");
    //var isDenda = denda!.isNegative ? true.obs : false.obs;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: AppBar(
          elevation: 5,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 60, bottom: 13),
            title: Text(
              "Pengembalian Buku",
              style: TextStyle(
                  fontFamily: "Montserrat", fontSize: 18, color: Colors.white),
            ),
          ),
          backgroundColor: Color(0xff5C549A),
        ),
      ),
      body: FutureBuilder<List<BorrowsData>>(
        future: fetchBorrowById(id: "A210802643"),
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
            denda = CardBorrow.returnCountDown(
              year: int.parse(data.tanggal!.substring(0, 4)),
              month: int.parse(data.tanggal!.substring(5, 7)),
              day: int.parse(data.tanggal!.substring(8, 10)),
              durasi: int.parse(data.durasi!),
            );
            isDenda = denda!.isNegative.obs;
            print("---Denda = $denda---");
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
                      margin: EdgeInsets.fromLTRB(3, 0, 3, 17),
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
                            SizedBox(height: 17),

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
                                    tgl
                                      ..text = DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now());
                                    FocusScope.of(context).unfocus();
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
                          Obx(
                            () {
                              return Switch(
                                value: isDenda.value,
                                onChanged: (val) {
                                  isDenda.value = val;
                                },
                              );
                            },
                           ),
                          //Obx(
                          //   () {
                          //     return Switch(
                          //       value: isDenda.value,
                          //       onChanged: (val) {
                          //         isDenda.value = val;
                          //       },
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                    ),

                    //Form Denda
                    // Container(
                    //   child: Obx(() => showFormDenda(isDenda.value)!),
                    // ),


                    SizedBox(
                      height: 50,
                    ),

                    //Button Selesai
                    ElevatedButton(
                      child: Text(
                        "KEMBALIKAN BUKU",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 13,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                        padding: EdgeInsets.fromLTRB(30, 13, 30, 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () {
                        // if (tgl.text.isEmpty) {
                        //   Get.rawSnackbar(
                        //     messageText: Text(
                        //       "Masukan format waktu yang valid",
                        //       textAlign: TextAlign.center,
                        //       style: TextStyle(
                        //         fontSize: 13,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //     backgroundColor: Colors.redAccent,
                        //     padding: EdgeInsets.symmetric(
                        //       vertical: 12,
                        //       horizontal: 10,
                        //     ),
                        //     borderRadius: 5,
                        //   );
                        // } else {
                        //   //selesaiPinjam(context);
                        // }
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
                            //Navigator.pop(context);
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
          Obx(
            () => DropdownButtonFormField(
              hint: Text("Rusak/Cacat"),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              value: _selectedRusak.value,
              items: rusak.map((e) {
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
              onChanged: (dynamic val) {
                _selectedRusak.value = val;
                //setState(() {},);
              },
            ),
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

          Obx(
            () => Text(
              "DENDA : ${NumberFormat.currency(
                locale: 'id',
                symbol: 'Rp ',
                decimalDigits: 0,
              ).format(cetakDenda(denda!, _selectedRusak.value))}",
              style: TextStyle(
                fontSize: 14,
                fontFamily: "Montserrat",
                color: Colors.black45,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
