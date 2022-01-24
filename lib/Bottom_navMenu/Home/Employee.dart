import 'package:flutter/material.dart';
import 'package:library_app/Models/EmployeeData.dart';
import 'package:library_app/Widgets/CardEmployee.dart';

class Employee extends StatelessWidget {
  static final String TAG = '/Employee';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: CustomScrollView(
        slivers: [
          //APPBAR
          SliverAppBar(
            backgroundColor: Color(0xff5C549A),
            toolbarHeight: 50,
            expandedHeight: MediaQuery.of(context).size.height / 3.8, //230,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 50, bottom: 13),
              background: Image.asset(
                "images/Bg_Members.png",
                fit: BoxFit.cover,
              ),
              title: Text(
                "Pegawai",
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
                    //showSearch(context: context, delegate: MembersSearch());
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => AddMember(),
                    //   ),
                    // );
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
          FutureBuilder<List<EmployeeData>>(
            future: fetchEmployee(),
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
                        child: CardEmployee(
                          id: data.id,
                          nama: data.nama,
                          telp: data.telp,
                          jabatan: data.jabatan,
                          alamat: data.alamat,
                          gender: data.gender,
                          onTap: (){},
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
              margin: EdgeInsets.only(bottom: 40, top: 40),
            ),
          ),
        ],
      ),
    );
  }
}
