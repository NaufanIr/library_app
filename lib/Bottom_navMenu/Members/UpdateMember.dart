import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/Models/MembersData.dart';

class UpdateMember extends StatefulWidget {
  final id;

  UpdateMember({required this.id});

  @override
  _UpdateMemberState createState() => _UpdateMemberState();
}

class _UpdateMemberState extends State<UpdateMember> {
  String? _selectedGender;

  final List<String> genderList = [
    "Laki-laki",
    "Perempuan",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 13, bottom: 13),
            title: Text(
              "Edit Anggota",
              style: TextStyle(
                  fontFamily: "Montserrat", fontSize: 18, color: Colors.white),
            ),
          ),
          backgroundColor: Color(0xff5C549A),
          automaticallyImplyLeading: false,
        ),
      ),
      body: FutureBuilder<List<MembersData>>(
        future: fetchMemberById(id: widget.id),
        builder: (context, snapshot) {
          print("=============== REFRESH ===============");
          if (snapshot.data == null) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final data = snapshot.data![0];
            TextEditingController nama =
                TextEditingController(text: "${data.nama}");
            TextEditingController kelas =
                TextEditingController(text: "${data.kelas}");
            TextEditingController telp =
                TextEditingController(text: "${data.telp}");
            TextEditingController alamat =
                TextEditingController(text: "${data.alamat}");
            print("$_selectedGender");
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(5, 20, 5, 30),
              child: Column(
                children: [
                  //BIODATA
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                          )
                        ]),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Data Diri",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 17),

                          //NAMA
                          TextField(
                            controller: nama,
                            decoration: InputDecoration(
                              labelText: "Nama Lengkap",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 17),

                          //KELAS
                          TextField(
                            controller: kelas,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: "Kelas",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 17),

                          //NO.TELP
                          TextField(
                            controller: telp,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: "No.Telp",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 17),

                          //DROPDOWN GENDER
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder()
                            ),
                            hint: Text("Jenis Kelamin"),
                            value:
                            data.gender == "L" ? genderList[0] : genderList[1],
                            items: genderList.map(
                              (val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(val),
                                );
                              },
                            ).toList(),
                            onChanged: (String? val) {
                              setState(() {
                                  _selectedGender = val!;
                                });
                              print("onChanged : $_selectedGender || $val");
                            },
                          ),
                          SizedBox(height: 17),

                          //ALAMAT
                          TextField(
                            controller: alamat,
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: "Alamat",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50),

                  //BUTTON SIMPAN
                  ElevatedButton(
                    child: Text("SIMPAN",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 12,
                            color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                      padding: EdgeInsets.fromLTRB(35, 13, 35, 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    onPressed: () {
                      print(_selectedGender);
                      if (nama.text.isEmpty ||
                          kelas.text.isEmpty ||
                          telp.text.isEmpty ||
                          alamat.text.isEmpty) {
                        Get.rawSnackbar(
                          messageText: Text(
                            "Semua data wajib diisi",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.redAccent,
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 10,
                          ),
                          borderRadius: 5,
                        );
                      } else {
                        print("SIMPAN = $_selectedGender");
                        updtMember(
                          id: data.id,
                          nama: nama.text,
                          kelas: kelas.text,
                          telp: telp.text,
                          alamat: alamat.text,
                          gender: _selectedGender == "Perempuan" ? "P" : "L",
                        ).then(
                          (val) {
                            Navigator.pop(context);
                            Get.rawSnackbar(
                              messageText: Text(
                                "Berhasil merubah data anggota",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor:
                              Colors.blueAccent.withOpacity(0.93),
                              dismissDirection:
                              SnackDismissDirection.HORIZONTAL,
                              margin: EdgeInsets.symmetric(
                                vertical: 80,
                                horizontal: 15,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 10,
                              ),
                              borderRadius: 5,
                            );
                          },
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),

                  //BUTTON BATAL
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        splashColor: Colors.black26,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(30, 13, 30, 13),
                          child: Text(
                            "KEMBALI",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 14,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
