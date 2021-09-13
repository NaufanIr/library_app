import 'package:flutter/material.dart';
import 'package:library_app/Models/ReturnsData.dart';
import 'package:library_app/Widgets/CardReturn.dart';

class ReturnList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: CustomScrollView(
        slivers: [
          //APPBAR
          SliverAppBar(
            backgroundColor: Color(0xff5C549A),
            toolbarHeight: 50,
            expandedHeight: MediaQuery.of(context).size.height / 3.8,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 50, bottom: 15),
              background: Image.asset(
                "images/Bg_Schedule.png",
                fit: BoxFit.cover,
              ),
              title: Text(
                "Daftar Pengembalian Buku",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 15,
                    color: Colors.white),
              ),
            ),
          ),

          //MARGIN TO LIST RETURN SCHEDULE
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(bottom: 15),
            ),
          ),

          //LIST PENGEMBALIAN BUKU
          FutureBuilder<List<ReturnData>>(
            future: fetchReturn(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return SliverList(
                  delegate: SliverChildListDelegate([
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var data = snapshot.data[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 8),
                        child: CardReturn(
                          id: data.id,
                          idPinjam: data.idPeminjaman,
                          nama: data.nama,
                          buku: data.judul,
                          tanggal: data.tanggal,
                          denda: data.denda,
                          onTap: (){
                            popUp(
                              context: context,
                              id: data.id,
                              idPeminjaman: data.idPeminjaman,
                              tanggal: data.tanggal,
                              denda: data.denda,
                              keterangan: data.keterangan,
                              nama: data.nama,
                              judul: data.judul,
                              tglPinjam: data.tglPinjam,
                              durasi: data.durasi,
                            );
                          },
                        ),
                      );
                    },
                    childCount: snapshot.data.length,
                  ),
                );
              }
            },
          ),

          //MARGIN TO BOTTOM
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(bottom: 135),
            ),
          ),
        ],
      ),
    );
  }

  Future popUp({
    @required BuildContext context,
    @required String id,
    @required String idPeminjaman,
    @required String tanggal,
    @required String denda,
    @required String keterangan,
    @required String nama,
    @required String judul,
    @required String tglPinjam,
    @required String durasi,
  }) async {
    await Future.delayed(Duration(milliseconds: 250));
    return showDialog(
      context: context,
      builder: (context) {
        double fontSize = 12;
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.9),
              ),
              child: Column(
                children: [
                  //HEADER
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Colors.orange[300],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(0,3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(CardReturn.tanggalGenerator(tgl: tanggal),
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xff6A639F),
                        ),
                      ),
                    ),
                  ),

                  //DETAILS
                  Container(
                    //color: Colors.redAccent,
                    height: MediaQuery.of(context).size.height/2.5,
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //ID PINJAM
                        Row(
                          children: [
                            Text(
                              "No : ",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: fontSize,
                                color: Color(0xff5C549A),
                              ),
                            ),
                            Text(
                              id,
                              style: TextStyle(
                                fontSize: fontSize,
                                color: Color(0xff5C549A),
                              ),
                            ),
                          ],
                        ),

                        //NAMA
                        Row(
                          children: [
                            Text(
                              "Nama : ",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: fontSize,
                                color: Color(0xff5C549A),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                nama,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Color(0xff5C549A),
                                ),
                              ),
                            ),
                          ],
                        ),

                        //BUKU
                        Row(
                          children: [
                            Text(
                              "Buku : ",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: fontSize,
                                color: Color(0xff5C549A),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                judul,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Color(0xff5C549A),
                                ),
                              ),
                            ),
                          ],
                        ),

                        //TGL PINJAM
                        Row(
                          children: [
                            Text(
                              "Tgl.Pinjam : ",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: fontSize,
                                color: Color(0xff5C549A),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                CardReturn.tanggalGenerator(tgl: tglPinjam),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Color(0xff5C549A),
                                ),
                              ),
                            ),
                          ],
                        ),

                        //DURASI
                        Row(
                          children: [
                            Text(
                              "Durasi : ",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: fontSize,
                                color: Color(0xff5C549A),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "$durasi Hari",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Color(0xff5C549A),
                                ),
                              ),
                            ),
                          ],
                        ),

                        //DENDA
                        Row(
                          children: [
                            Text(
                              "Denda : ",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: fontSize,
                                color: Color(0xff5C549A),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                CardReturn.dendaGenerator(denda),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Color(0xff5C549A),
                                ),
                              ),
                            ),
                          ],
                        ),

                        //KET
                        Row(
                          children: [
                            Expanded(
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Keteragan : ",
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: fontSize,
                                        color: Color(0xff5C549A),
                                      ),
                                    ),
                                    TextSpan(
                                      text: keterangan == null ? " -" : keterangan,
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Color(0xff5C549A),
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  //ID PEMINJAMAN
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 25),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0,3),
                        ),
                      ],
                    ),
                    child: Text(
                      "ID : $idPeminjaman",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        letterSpacing: 1.3,
                        fontSize: 13,
                        color: Colors.white,//Color(0xff5C549A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}