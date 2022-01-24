import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:library_app/Bottom_navMenu/Books/AddBook.dart';
import 'package:library_app/Bottom_navMenu/Books/Borrow.dart';
import 'package:library_app/Bottom_navMenu/Books/UpdateBook.dart';
import 'package:library_app/Models/BooksData.dart';
import 'package:library_app/Search.dart';
import 'package:library_app/Widgets/CardBook.dart';

class Books extends StatelessWidget {
  var pinned = true.obs;
  var scrollController = ScrollController();
  void scrollDetection() {
    scrollController = ScrollController()
      ..addListener(
        () {
          scrollController.position.userScrollDirection ==
                  ScrollDirection.forward
              ? pinned.value = true
              : pinned.value = false;
        },
      );
  }

  Future popUp({
    required BuildContext context,
    required String? id,
    required String? judul,
    required String? pengarang,
    required String? penerbit,
    required String? tahun,
  }) async {
    await Future.delayed(Duration(milliseconds: 250));
    return showDialog(
      context: context,
      builder: (context) {
        return dialogMenu(
          context,
          id: id,
          judul: judul,
          pengarang: pengarang,
          penerbit: penerbit,
          tahun: tahun,
        );
      },
    );
  }

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

  @override
  Widget build(BuildContext context) {
    print("=== $pinned ===");
    scrollDetection();
    return Scaffold(
      backgroundColor: Color(0x1f5C549A),
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          //APPBAR
          SliverAppBar(
            pinned: true,
            toolbarHeight: 50,
            expandedHeight: MediaQuery.of(context).size.height / 3.8,
            backgroundColor: Color(0xff5C549A),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 60.0, bottom: 13),
              title: Text(
                "Buku",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 18,
                    color: Colors.white),
              ),
              background: Image.asset(
                "images/Bg_Schedule.png",
                fit: BoxFit.cover,
              ),
              collapseMode: CollapseMode.parallax,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: IconButton(
                  icon: Icon(Icons.search),
                  iconSize: 30,
                  splashColor: Colors.orange[300],
                  onPressed: () {
                    showSearch(context: context, delegate: BooksSearch());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IconButton(
                  icon: Icon(Icons.add),
                  iconSize: 30,
                  splashColor: Colors.orange[300],
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddBook(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          Obx(
            () => SliverPersistentHeader(
                //floating: pinned.value,
                pinned: pinned.value,
                delegate: SearchBar(),
              ),
          ),

          SliverToBoxAdapter(
            child: Container(margin: EdgeInsets.only(top: 5)),
          ),

          //CARD BUKU
          FutureBuilder<List<BooksData>>(
            future: fetchBooks(),
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
                      return Padding(
                        padding: EdgeInsets.all(7),
                        child: CardBook(
                          id: data.id,
                          judul: data.judul,
                          pengarang: data.pengarang,
                          penerbit: data.penerbit,
                          tahun: data.tahun,
                          jumlah: int.parse(data.jumlah!),
                          onTap: () {
                            popUp(
                              context: context,
                              id: data.id,
                              judul: data.judul,
                              pengarang: data.pengarang,
                              penerbit: data.penerbit,
                              tahun: data.tahun,
                            );
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
            child: SizedBox(
              height: 80,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Flexible(
              flex: 13,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 32, 20, 0),
                    width: MediaQuery.of(context).size.width,
                    //color: Colors.deepPurple,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/Bg_Login.png"),
                          fit: BoxFit.fill),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    child: Text(
                      "KATEGORI BUKU",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 30,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.orange[300],
                child: ListView(
                  padding: EdgeInsets.only(top: 20, bottom: 90),
                  children: [
                    kategoriDrawer(caption: "Komputer"),
                    kategoriDrawer(caption: "Novel"),
                    kategoriDrawer(caption: "Biografi"),
                    kategoriDrawer(caption: "Jurnal"),
                    kategoriDrawer(caption: "Fiksi"),
                    kategoriDrawer(caption: "Buku Anak"),
                    kategoriDrawer(caption: "Ekonomi"),
                    kategoriDrawer(caption: "Keuangan"),
                    kategoriDrawer(caption: "Kesehatan"),
                    kategoriDrawer(caption: "Sains"),
                    kategoriDrawer(caption: "Agama"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Material kategoriDrawer({required String caption, Function? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.blue[500],
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black12),
            ),
          ),
          padding: EdgeInsets.all(15),
          child: Text(
            "$caption",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
        ),
        onTap: () {},
      ),
    );
  }

  Dialog dialogMenu(
    BuildContext context, {
    required String? id,
    required String? judul,
    required String? pengarang,
    required String? penerbit,
    required String? tahun,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //BUKU
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: CardBook(
                    id: id,
                    judul: judul,
                    pengarang: pengarang,
                    penerbit: penerbit,
                    tahun: tahun,
                  ),
                ),

                //BUTTON PINJAM
                RaisedButton(
                  splashColor: Colors.black54,
                  child: Text(
                    "PINJAM",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 12,
                        color: Colors.grey[200]),
                  ),
                  color: Color(0xff5C549A),
                  padding: EdgeInsets.fromLTRB(66, 13, 66, 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Borrow(idBuku: id)),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),

                //BUTTON EDIT
                RaisedButton(
                  splashColor: Colors.black54,
                  child: Text(
                    "EDIT",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 12,
                      color: Color(0xff5C549A),
                    ),
                  ),
                  color: Colors.orange[300],
                  padding: EdgeInsets.fromLTRB(75, 13, 75, 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    Get.back();
                    Get.toNamed('${UpdateBook.TAG}/$id');
                    // Get.off(UpdateBook(id: id));
                  },
                ),

                //BUTTON HAPUS
                Container(
                  height: 50,
                  width: 180,
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40),
                      splashColor: Colors.black26,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.only(top: 13, bottom: 13),
                        child: Center(
                          child: Text(
                            "HAPUS",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 14,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        print("ID BUKU = $id");
                        delBook(id: id).then(
                          (value) {
                            Navigator.pop(context);
                            // Toast.show("Buku telah dihapus", context);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 10, left: 7, right: 7),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.9),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          cursorColor: Colors.black12,
          decoration: InputDecoration(
            border: InputBorder.none,
            //focusColor: Colors.white,
            hintStyle: TextStyle(fontSize: 17),
            hintText: "Cari Buku...",
            suffixIcon: IconButton(
              icon: Icon(
                Icons.search,
                color: FocusNode().hasFocus ? Colors.white : Colors.black45,
              ),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 50;

  @override
  // TODO: implement minExtent
  double get minExtent => 50;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
