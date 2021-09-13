import 'package:flutter/material.dart';
import 'package:library_app/Models/BooksData.dart';
import 'package:toast/toast.dart';

class UpdateBook extends StatelessWidget {
  final id;

  UpdateBook({@required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 13, bottom: 13),
            title: Text(
              "Edit Buku",
              style: TextStyle(
                  fontFamily: "Montserrat", fontSize: 18, color: Colors.white),
            ),
          ),
          backgroundColor: Color(0xff5C549A),
          automaticallyImplyLeading: false,
        ),
      ),
      body: FutureBuilder<List<BooksData>>(
        future: fetchBookById(id: this.id),
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
            final data = snapshot.data[0];
            var noRak = data.id.substring(2, 4);
            TextEditingController judul =
                TextEditingController(text: "${data.judul}");
            TextEditingController pengarang =
                TextEditingController(text: "${data.pengarang}");
            TextEditingController penerbit =
                TextEditingController(text: "${data.penerbit}");
            TextEditingController tahun =
                TextEditingController(text: "${data.tahun}");
            TextEditingController jumlah =
                TextEditingController(text: "${data.jumlah}");
            TextEditingController rak = TextEditingController(text: "$noRak");
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(5, 20, 5, 30),
              child: Column(
                children: [
                  //DATA BUKU
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors
                          .white, //Color(0xff5C599B), //Colors.orange[300],
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

                          //TF JUDUL BUKU
                          TextField(
                            controller: judul,
                            decoration: InputDecoration(
                              labelText: "Judul",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 17),

                          //TF PENGARANG
                          TextField(
                            controller: pengarang,
                            decoration: InputDecoration(
                              labelText: "Pengarang",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 17),

                          ////TF PENERBIT
                          TextField(
                            controller: penerbit,
                            decoration: InputDecoration(
                              labelText: "Penerbit",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 17),

                          //TF TAHUN
                          TextField(
                            controller: tahun,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              labelText: "Tahun Terbit",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 17),

                          //TF JUMLAH
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
                  SizedBox(height: 50),

                  //BUTTON SIMPAN
                  RaisedButton(
                    child: Text("SIMPAN",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 12,
                            color: Colors.white)),
                    color: Colors.blueAccent,
                    padding: EdgeInsets.fromLTRB(35, 13, 35, 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    onPressed: () {
                      if (judul.text.isEmpty ||
                          pengarang.text.isEmpty ||
                          penerbit.text.isEmpty ||
                          tahun.text.isEmpty ||
                          jumlah.text.isEmpty) {
                        Toast.show(
                          "Semua data wajib diisi",
                          context,
                          duration: 2,
                          backgroundColor:
                              Colors.redAccent.shade700.withOpacity(0.7),
                          gravity: Toast.CENTER,
                        );
                      } else {
                        updateBook(
                          id: data.id,
                          judul: judul.text,
                          pengarang: pengarang.text,
                          penerbit: penerbit.text,
                          tahun: tahun.text,
                          jumlah: jumlah.text,
                        ).then(
                          (val) {
                            Navigator.pop(context);
                            Toast.show(
                              "Berhasil merubah data buku",
                              context,
                              duration: 3,
                              backgroundColor: Colors.blueAccent,
                              gravity: Toast.BOTTOM,
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
            );
          }
        },
      ),
    );
  }
}
