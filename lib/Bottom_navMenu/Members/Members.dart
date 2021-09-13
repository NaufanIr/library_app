import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:library_app/Bottom_navMenu/Members/AddMember.dart';
import 'package:library_app/Bottom_navMenu/Members/UpdateMember.dart';
import 'package:library_app/Models/MembersData.dart';
import 'package:library_app/Widgets/CardMember.dart';
import '../../Search.dart';

class Members extends StatefulWidget {
  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {

  ///STREAM BUILDER
  // Timer timer;
  // StreamController<List> streamController = StreamController();
  // Future<List> getMembers() async {
  //   var response = await http.get("${API.showAnggota}");
  //   final data = json.decode(response.body);
  //   streamController.add(data);
  // }
  //
  // @override
  // void initState() {
  //   getMembers();
  //   timer = Timer.periodic(Duration(seconds: 3), (timer) => getMembers());
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

  Future popUp({
    @required String nama,
    @required String id,
    @required String kelas,
    @required String telp,
    @required String alamat,
    @required String gender,
  }) async {
    await Future.delayed(Duration(milliseconds: 250));
    return showDialog(
      context: context,
      builder: (context) {
        return dialogMenu(
            context,
            nama: nama,
            id: id,
            kelas: kelas,
            telp: telp,
            alamat: alamat,
            gender: gender,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x1f5C549A),
      body: CustomScrollView(
        slivers: [
          //APPBAR
          SliverAppBar(
            backgroundColor: Color(0xff5C549A),
            toolbarHeight: 50,
            expandedHeight: MediaQuery.of(context).size.height / 3.8, //230,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 20, bottom: 13),
              background: Image.asset(
                "images/Bg_Members.png",
                fit: BoxFit.cover,
              ),
              title: Text(
                "Members",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 18,
                    color: Colors.white),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: IconButton(
                  icon: Icon(Icons.search),
                  iconSize: 30,
                  splashColor: Colors.orange[300],
                  onPressed: () {
                    showSearch(context: context, delegate: MembersSearch());
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
                        builder: (context) => AddMember(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          //MARGIN TO APPBAR
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),

          //CARD ANGGOTA
          FutureBuilder<List<MembersData>>(
            future: fetchMembers(),
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
                      return Padding(
                        padding: EdgeInsets.all(7),
                        child: CardMember(
                          id: data.id,
                          nama: data.nama,
                          kelas: data.kelas,
                          telp: data.telp,
                          alamat: data.alamat,
                          gender: data.gender,
                          onTap: (){
                           popUp(
                             id: data.id,
                             nama: data.nama,
                             kelas: data.kelas,
                             telp: data.telp,
                             alamat: data.alamat,
                             gender: data.gender,
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

          ///CARD ANGGOTA WITH STREAM BUILDER
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
          //             return cardMember(context, snapshot, index);
          //           },
          //           childCount: snapshot.data.length,
          //         ),
          //       );
          //     }
          //   },
          // ),

          //MARGIN TO NAVBAR

          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(bottom: 40, top: 40),
            ),
          ),
        ],
      ),
    );
  }

  Dialog dialogMenu(
      BuildContext context,
      {@required String nama,
        @required String id,
        @required String kelas,
        @required String telp,
        @required String alamat,
        @required String gender,}) {
    int typeCard = 2;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
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
              //CARD MEMBER
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: CardMember(
                  id: id,
                  nama: nama,
                  kelas: kelas,
                  telp: telp,
                  alamat: alamat,
                  gender: gender,
                  typeCard: typeCard,
                ),
              ),

              //BUTTON EDIT
              RaisedButton(
                splashColor: Colors.black54,
                child: Text(
                  "EDIT",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 13,
                    color: Color(0xff5C549A),
                  ),
                ),
                color: Colors.orange[300],
                padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateMember(id: id)),
                  );
                },
              ),

              //BUTTON HAPUS
              Container(
                 height: 50,
                 width: 100,
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(40),
                    splashColor: Colors.black26,
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: Center(
                        child: Text(
                          "HAPUS",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 13,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}