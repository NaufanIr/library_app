import 'package:flutter/material.dart';
import 'package:library_app/Bottom_navMenu/Home/BookReturn.dart';
import 'package:library_app/Models/BorrowsData.dart';
import 'package:library_app/Widgets/CardBorrow.dart';

class BorrowsList extends StatefulWidget {
  @override
  _BorrowsListState createState() => _BorrowsListState();
}

class _BorrowsListState extends State<BorrowsList> {

  /// STREAM BUILDER
  // StreamController<List> streamController = StreamController();
// Timer timer;
//
// Future<List> getPeminjaman() async {
//   var response = await http.get("${API.showPeminjaman}");
//   final data = json.decode(response.body);
//   streamController.add(data);
// }
//
// @override
// void initState() {
//   getPeminjaman();
//   timer = Timer.periodic(Duration(seconds: 3), (timer) => getPeminjaman());
//   super.initState();
// }
//
// @override
// void dispose() {
//   if (timer.isActive) {
//     timer.cancel();
//   }
//   super.dispose();
// }

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
                      final data = snapshot.data[index];
                      var tahun = int.parse(
                          data.tanggal.substring(0, 4));
                      var bulan = int.parse(
                          data.tanggal.substring(5, 7));
                      var hari = int.parse(
                          data.tanggal.substring(8, 10));
                      var duration = int.parse(data.durasi);
                      return Padding(
                        padding: EdgeInsets.all(7),
                        child: CardBorrow(
                          id: data.id,
                          judul: data.judul,
                          peminjam: data.nama,
                          tanggal: data.tanggal,
                          durasi: data.durasi,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return bookReturn(
                                    id: data.id,
                                    denda: CardBorrow.returnCountDown(
                                      year: tahun,
                                      month: bulan,
                                      day: hari,
                                      durasi: duration,
                                    ),
                                  );
                                },
                              ),
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

          ///LIST CARD RETURN SCHEDULE --WITH STREAM BUILDER
          // StreamBuilder(
//   stream: streamController.stream,
//   builder: (context, snapshot) {
//     if (snapshot.data == null) {
//       return SliverList(
//         delegate: SliverChildListDelegate(
//           [
//             Container(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//           ],
//         ),
//       );
//     } else {
//       return SliverList(
//         delegate: SliverChildBuilderDelegate(
//           (BuildContext context, int index) {
//             return Padding(
//               padding:
//                   EdgeInsets.symmetric(vertical: 11, horizontal: 7),
//               child: CardBorrow(
//                 context: context,
//                 snapshot: snapshot,
//                 index: index,
//                 id: snapshot.data[index]['kd_peminjaman'],
//                 judul: snapshot.data[index]['judul'],
//                 peminjam: snapshot.data[index]['nama'],
//                 tanggal: snapshot.data[index]['tgl_peminjaman'],
//                 durasi: snapshot.data[index]['durasi'],
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) {
//                         return bookReturn(
//                           id: snapshot.data[index]['kd_peminjaman'],
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//             );
//             //cardReturnDeadline(context, snapshot, index);
//           },
//           childCount: snapshot.data.length,
//         ),
//       );
//     }
//   },
// ),

//MARGIN BOTTOM

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