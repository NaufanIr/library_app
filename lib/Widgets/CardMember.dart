import 'package:flutter/material.dart';

class CardMember extends StatelessWidget {
  final String? id, nama, kelas, telp, alamat, gender;
  int? typeCard = 1;
  final int? index;
  final Function? onTap;
  final BuildContext? context;
  final AsyncSnapshot? snapshot;

  CardMember(
      {required this.id,
      required this.nama,
      required this.kelas,
      required this.telp,
      required this.alamat,
      required this.gender,
      this.typeCard,
      this.index,
      this.onTap,
      this.context,
      this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.blue[400],
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 20, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //NAMA
                Text(
                  nama!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 14,
                    color: Color(0xff5C549A),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //GAMBAR KATEGORI
                    Container(
                      height: typeCard == 2 ? 60 : 70,
                      width: typeCard == 2 ? 60 : 70,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(gender == 'L'
                                ? "images/boy.png"
                                : "images/girl.png"),
                            fit: BoxFit.cover),
                      ),
                    ),

                    //PEMISAH
                    Container(
                      margin: EdgeInsets.only(left: 7.5, right: 15),
                      height: 110,
                      width: 3,
                      color: Color(0xff5C549A),
                    ),

                    //DESKRIPSI
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 105,
                        //color: Colors.redAccent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //ID
                            Text(
                              "ID : $id",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: typeCard == 2 ? 9.5 : 10.5,
                                color: Color(0xff5C549A),
                              ),
                            ),

                            //KELAS
                            Row(
                              children: [
                                Text(
                                  "Kelas : ",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: typeCard == 2 ? 9.5 : 10.5,
                                    color: Color(0xff5C549A),
                                  ),
                                ),
                                Text(
                                  kelas!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: typeCard == 2 ? 9.5 : 10.5,
                                    color: Color(0xff5C549A),
                                  ),
                                ),
                              ],
                            ),

                            //NO.TELP
                            Row(
                              children: [
                                Text(
                                  "No.Telp : ",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: typeCard == 2 ? 9.5 : 10.5,
                                    color: Color(0xff5C549A),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    telp!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: typeCard == 2 ? 9.5 : 10.5,
                                      color: Color(0xff5C549A),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            //ALAMAT
                            Row(
                              children: [
                                Expanded(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Alamat : ",
                                          style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize:
                                                typeCard == 2 ? 9.5 : 10.5,
                                            color: Color(0xff5C549A),
                                          ),
                                        ),
                                        TextSpan(
                                          text: alamat,
                                          style: TextStyle(
                                            fontSize:
                                                typeCard == 2 ? 9.5 : 10.5,
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
