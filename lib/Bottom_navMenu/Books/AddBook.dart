import 'package:flutter/material.dart';
import 'package:library_app/Models/BooksData.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class AddBook extends StatefulWidget {
  static final String TAG = '/AddBook';

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  TextEditingController judul = TextEditingController();
  TextEditingController pengarang = TextEditingController();
  TextEditingController penerbit = TextEditingController();
  TextEditingController tahun = TextEditingController();
  TextEditingController rak = TextEditingController();
  TextEditingController jumlah = TextEditingController();

  //ID COUNTER
  int idCounter = 0;
  void setPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("idBuku", idCounter);
  }

  void getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idCounter = pref.getInt("idBuku") ?? 0;
    });
  }

  var _genre = "LA (Lainnya)".obs;
  final List<String> genre = [
    "AB (Auto Biografi)",
    "KP (Komputer)",
    "NV (Novel)",
    "PB (Pembelajaran)",
    "LA (Lainnya)"
  ];

  void clear() {
    judul.clear();
    pengarang.clear();
    penerbit.clear();
    tahun.clear();
    jumlah.clear();
    rak.clear();
    rak.clear();
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    print("=============== REFRESH ===============");
    print("=====${_genre.value}=====");
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 50, bottom: 14),
            title: Text(
              "Tambah Buku",
              style: TextStyle(
                  fontFamily: "Montserrat", fontSize: 18, color: Colors.white),
            ),
          ),
          backgroundColor: Color(0xff5C549A),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 20, 5, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //IMAGE
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Lottie.network(
                    "https://assets5.lottiefiles.com/packages/lf20_DMgKk1.json"),
              ),
              SizedBox(height: 20),

              //DATA BUKU
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Data Buku",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: 17),
                      TextField(
                        controller: judul,
                        decoration: InputDecoration(
                          labelText: "Judul",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 17),
                      TextField(
                        controller: pengarang,
                        decoration: InputDecoration(
                          labelText: "Pengarang",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 17),
                      TextField(
                        controller: penerbit,
                        decoration: InputDecoration(
                          labelText: "Penerbit",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 17),
                      TextField(
                        controller: tahun,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          labelText: "Tahun Terbit",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 17),
                      TextField(
                        controller: jumlah,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Jumlah",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),

              //LAINNYA
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orange[300], //Colors.deepPurple[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Lainnya",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: 17),

                      //DROPDOWN GENRE
                      Obx(
                        () => DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "Genre",
                            border: OutlineInputBorder(),
                          ),
                          value: _genre.value,
                          items: genre.map((e) {
                            return DropdownMenuItem(
                                value: e, child: Text(e));
                          }).toList(),
                          onChanged: (dynamic val) {
                            _genre.value = val;
                          },
                        ),
                      ),
                      SizedBox(height: 17),

                      TextField(
                        controller: rak,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "No.Rak",
                          hintText: "Ex: 01",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),

              //Button Tambahakan Buku
              ElevatedButton(
                child: Text(
                  "TAMBAHKAN",
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 12,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  padding: EdgeInsets.fromLTRB(50, 13, 50, 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {
                  if (judul.text.isEmpty ||
                      pengarang.text.isEmpty ||
                      penerbit.text.isEmpty ||
                      tahun.text.isEmpty ||
                      jumlah.text.isEmpty ||
                      rak.text.isEmpty
                      //_genre.value == null
                  ) {
                    Get.rawSnackbar(
                      messageText: Text(
                        "Semua data wajib diisi",
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
                    var id = _genre.value.substring(0, 2) +
                        rak.text +
                        idCounter.toString().padLeft(3, "0");
                    addBook(
                      id: id,
                      judul: judul.text,
                      pengarang: pengarang.text,
                      penerbit: penerbit.text,
                      tahun: tahun.text,
                      jumlah: jumlah.text,
                    ).then(
                      (value) {
                        idCounter++;
                        setPref();
                        clear();
                        Get.rawSnackbar(
                          messageText: Text(
                            "Buku berhasil ditambahkan",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 10,
                          ),
                          borderRadius: 5,
                        );
                      },
                    );
                  }
                },
              ),
              SizedBox(height: 20),

              //BUTTON BATAL
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
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
