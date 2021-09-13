import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardBorrow extends StatelessWidget {
  final String id, judul, peminjam, tanggal, durasi;
  final Function onTap;

  CardBorrow({
    @required this.id,
    @required this.judul,
    @required this.peminjam,
    @required this.tanggal,
    @required this.durasi,
    this.onTap,
  });

//BOOK RETURN DATE
  String returnDate({int year, int month, int day, int durasi}) {
    var returnDate = DateTime(year, month, day).add(Duration(days: durasi));
    return DateFormat("d MMM").format(returnDate).toString().toUpperCase();
  }

//BOOK RETURN DAY COUNTDOWN
  static int returnCountDown({int year, int month, int day, int durasi}) {
    var today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var returnDate = DateTime(year, month, day).add(Duration(days: durasi));
    var countDown = returnDate.difference(today).inDays;
    return countDown;
  }

  String displayCountDown(int countDown) {
    if (countDown >= 2) {
      return "$countDown Days Left";
    } else if (countDown == 1) {
      return "$countDown Day Left";
    } else if (countDown == 0) {
      return "TODAY";
    } else if (countDown == -1) {
      return "${countDown * -1} Day Late";
    } else {
      return "${countDown * -1} Days Late";
    }
  }

  @override
  Widget build(BuildContext context) {
    var tahun = int.parse(tanggal.toString().substring(0, 4));
    var bulan = int.parse(tanggal.toString().substring(5, 7));
    var hari = int.parse(tanggal.toString().substring(8, 10));
    var duration = int.parse(durasi);

    String tglKembali =
        returnDate(year: tahun, month: bulan, day: hari, durasi: duration);

    int countDown =
        returnCountDown(year: tahun, month: bulan, day: hari, durasi: duration);

    String resultCountDown = displayCountDown(countDown);

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            image: AssetImage("images/Bg_cardReturn.png"), fit: BoxFit.cover),
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
            children: [
              //KET TGL/WAKTU BUKU KEMBALI & ID
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.orange[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 195,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            tglKembali,
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 17,
                              color:  countDown.isNegative ? Colors.red[800] : Color(0xff6A639F),
                            ),
                          ),
                          Text(
                            " | ",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 17,
                              color: countDown.isNegative ? Colors.red[800] : Color(0xff6A639F),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              resultCountDown,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 13,
                                color: countDown.isNegative ? Colors.red[800] : Color(0xff6A639F),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue[400],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "ID : $id",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 10,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //DETAIL
              Container(
                height: 145,
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // JUDUL BUKU
                    Row(
                      children: [
                        Text(
                          "Judul Buku : ",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 11,
                            color: Color(0xff5C549A),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            judul,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xff5C549A),
                            ),
                          ),
                        ),
                      ],
                    ),

                    //NAMA PEMINJAM
                    Row(
                      children: [
                        Text(
                          "Peminjam : ",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 11,
                            color: Color(0xff5C549A),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            peminjam,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xff5C549A),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // TGL PINJAM BUKU
                    Row(
                      children: [
                        Text(
                          "Tgl.Pinjam : ",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 11,
                            color: Color(0xff5C549A),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            DateFormat("d MMMM yyyy")
                                .format(DateTime(tahun, bulan, hari))
                                .toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
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
                            fontSize: 11,
                            color: Color(0xff5C549A),
                          ),
                        ),
                        Text(
                          "$durasi Hari",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xff5C549A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}