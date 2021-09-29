import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardBook extends StatelessWidget {

  final String? id, judul, pengarang, penerbit, tahun;
  final int? jumlah, index;
  final Function? onTap;
  final BuildContext? context;
  final AsyncSnapshot? snapshot;

  CardBook({
    required this.id,
    required this.judul,
    required this.pengarang,
    required this.penerbit,
    required this.tahun,
    this.jumlah,
    this.onTap,
    this.context,
    this.snapshot,
    this.index,
  });

  String image(String id) {
    if (id.substring(0, 2) == "AB") {
      return "images/book/biografi.svg";
    } else if (id.substring(0, 2) == "KP") {
      return "images/book/komputer.svg";
    } else if (id.substring(0, 2) == "NV") {
      return "images/book/novel.svg";
    } else if (id.substring(0, 2) == "PB") {
      return "images/book/bahasa.svg";
    } else {
      return "images/book/komputer.svg";
    }
  }

  Widget showJumlah(int? jumlah){
    if(jumlah == null){
      return Container();
    }else{
      return Padding(
        padding: const EdgeInsets.only(top: 9),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Jumlah : ",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 11,
                  color: Color(0xff5C549A),
                ),
              ),
              TextSpan(
                text: jumlah.toString(),
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xff5C549A),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
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
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //JUDUL BUKU
                Text(
                  judul!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xff5C549A),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //GAMBAR KATEGORI & JUMLAH BUKU
                    Container(
                      height: 92,
                      //color: Colors.redAccent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "${image(id!)}",
                            height: jumlah == null ? 60 : 70,
                            width: jumlah == null ? 60 : 70,
                          ),
                          showJumlah(jumlah),
                        ],
                      ),
                    ),

                    //PEMISAH
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      height: 100,
                      width: 3,
                      color: Color(0xff5C549A),
                    ),

                    //DESKRIPSI
                    Flexible(
                      flex: 1,
                      child: Container(
                        //color: Colors.redAccent,
                        height: 93,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //ID
                            Text(
                              "ID : $id",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: jumlah == null ? 9 : 10,
                                color: Color(0xff5C549A),
                              ),
                            ),

                            //PENGARANG
                            Row(
                              children: [
                                Text(
                                  "Pengarang : ",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: jumlah == null ? 9 : 10,
                                    color: Color(0xff5C549A),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    pengarang!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: jumlah == null ? 9 : 10,
                                      color: Color(0xff5C549A),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            //PENERBIT
                            Row(
                              children: [
                                Text(
                                  "Penerbit : ",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: jumlah == null ? 9 : 10,
                                    color: Color(0xff5C549A),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    penerbit!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: jumlah == null ? 9 : 10,
                                      color: Color(0xff5C549A),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            //TAHUN
                            Row(
                              children: [
                                Text(
                                  "Tahun Terbit : ",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: jumlah == null ? 9 : 10,
                                    color: Color(0xff5C549A),
                                  ),
                                ),
                                Text(
                                  tahun!,
                                  style: TextStyle(
                                    fontSize: jumlah == null ? 9 : 10,
                                    color: Color(0xff5C549A),
                                  ),
                                ),
                              ],
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
          onTap: onTap as void Function()?,
        ),
      ),
    );
  }
}