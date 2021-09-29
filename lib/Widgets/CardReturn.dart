import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardReturn extends StatelessWidget {

  final String? id, idPinjam, nama, tanggal, denda, buku;
  final Function? onTap;

  CardReturn({
    required this.id,
    required this.idPinjam,
    required this.nama,
    required this.tanggal,
    required this.denda,
    required this.buku,
    this.onTap,
  });


  static String tanggalGenerator({String? tgl}){
    var tahun = int.parse(tgl.toString().substring(0, 4));
    var bulan = int.parse(tgl.toString().substring(5, 7));
    var hari = int.parse(tgl.toString().substring(8, 10));
    var date = DateTime(tahun, bulan, hari);
    return DateFormat("d MMMM yyyy").format(date).toString();
  }

  static String dendaGenerator(String? val){
    var denda = val == null ? 0 : int.parse(val);
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(denda).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            image: AssetImage("images/bgCard.png"), fit: BoxFit.cover),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: Colors.blue[400],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //TANGGAL PENGEMBALIAN
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 22),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.orange[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tanggalGenerator(tgl: tanggal),
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xff6A639F),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.blue[400],
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        "ID : $idPinjam",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //DETAILS
              Container(
                height: 90,
                margin: EdgeInsets.only(bottom: 5),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //NAMA PEMINJAM
                    Row(
                      children: [
                        Text(
                          "Peminjam : ",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 12,
                            color: Color(0xff5C549A),
                          ),
                        ),
                        Expanded(
                          child: Text(this.nama!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
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
                            fontSize: 12,
                            color: Color(0xff5C549A),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            this.buku!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
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
                            fontSize: 12,
                            color: Color(0xff5C549A),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            dendaGenerator(this.denda),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff5C549A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //NO : (ID PENGEMBALIAN)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10, right: 15),
                    //color: Colors.redAccent,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "No : ",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              color: Color(0xff5C549A),
                            ),
                          ),
                          TextSpan(
                            text: this.id,
                            style: TextStyle(
                              color: Color(0xff5C549A),
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
          onTap: onTap as void Function()?,
        ),
      ),
    );
  }
}