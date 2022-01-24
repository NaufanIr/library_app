import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/Bottom_navMenu/Home/BookReturn.dart';
import 'package:library_app/Models/BorrowsData.dart';
import 'package:library_app/Widgets/CardBorrow.dart';

class BorrowsList extends StatelessWidget {

  static final String TAG = '/BorrowList';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: CustomScrollView(
        slivers: [
          //APPBAR
          SliverAppBar(
            backgroundColor: Color(
                0xff5C549A), //Colors.deepPurple[400],//Colors.grey[300],//Color(0xff5C549A),
            toolbarHeight: 50,
            expandedHeight: MediaQuery.of(context).size.height / 3.8,
            pinned: true,
            //floating: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 50, bottom: 14),
              background: Image.asset(
                "images/Bg_Schedule.png",
                fit: BoxFit.cover,
              ),
              title: Text(
                "Daftar Peminjaman",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 17,
                    color: Colors.white),
              ),
            ),
          ),

          //MARGIN TO LIST RETURN SCHEDULE
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(bottom: 5, top: 5),
            ),
          ),

          FutureBuilder<List<BorrowsData>>(
            future: fetchBorrows(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
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
                      final data = snapshot.data![index];
                      var tahun = int.parse(
                          data.tanggal!.substring(0, 4));
                      var bulan = int.parse(
                          data.tanggal!.substring(5, 7));
                      var hari = int.parse(
                          data.tanggal!.substring(8, 10));
                      var duration = int.parse(data.durasi!);
                      return Padding(
                        padding: EdgeInsets.all(7),
                        child: CardBorrow(
                          id: data.id,
                          judul: data.judul,
                          peminjam: data.nama,
                          tanggal: data.tanggal,
                          durasi: data.durasi,
                          onTap: () {
                            //[GETX] GOING TO ROUTE /UpdateBook/HE90278
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) {
                            //       return BookReturn(
                            //         id: data.id,
                            //         denda: CardBorrow.returnCountDown(
                            //           year: tahun,
                            //           month: bulan,
                            //           day: hari,
                            //           durasi: duration,
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // );
                            Get.toNamed('${BookReturn.TAG}/${data.id}');
                            //Get.toNamed('${BookReturn.TAG}');
                          },
                        ),
                      );
                    },
                    childCount: snapshot.data!.length,
                  ),
                );
              }
            },
          ),

          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(bottom: 50),
            ),
          ),
        ],
      ),
    );
  }
}