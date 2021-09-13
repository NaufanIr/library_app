import 'package:flutter/material.dart';
import 'package:library_app/Models/MembersData.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMember extends StatefulWidget {
  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  TextEditingController nama = TextEditingController();
  TextEditingController kelas = TextEditingController();
  TextEditingController telp = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController thnAngkatan = TextEditingController();

  //ID COUNTER
  int idCounter = 0;
  void setPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("idAnggota", idCounter);
  }

  void getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idCounter = pref.getInt("idAnggota") ?? 1;
    });
  }

  String idGenerator({String kelas, String thnAngkatan, String idCounter}) {
    String kdJur = kelas.substring(2, 5);
    String id;
    if (kdJur == "IPA") {
      kdJur = "A";
    } else {
      kdJur = "S";
    }
    id = "${idCounter.toString().padLeft(3, "0")}";
    return "$kdJur$thnAngkatan$id";
  }

  //CLEAR DATA
  void clear() {
    nama.clear();
    kelas.clear();
    telp.clear();
    alamat.clear();
    thnAngkatan.clear();
    _selectedGender = null;
  }

  String _selectedGender;
  final List<String> genderList = [
    "Laki-laki",
    "Perempuan",
  ];

  @override
  void initState() {
    super.initState();
    getPref();
  }

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
              "Tambah Anggota",
              style: TextStyle(
                  fontFamily: "Montserrat", fontSize: 18, color: Colors.white),
            ),
          ),
          backgroundColor: Color(0xff5C549A),
          automaticallyImplyLeading: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 20, 5, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //IMAGE
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                //color: Colors.redAccent,
                child: Lottie.network(
                    "https://assets3.lottiefiles.com/private_files/lf30_4bVja9.json"),
              ),
              SizedBox(height: 20),

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

                      //TAHUN ANGKATAN
                      TextField(
                        controller: thnAngkatan,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Tahun Angkatan",
                          hintText: "Ex: 2010",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 17),

                      //DROPDOWN GENDER
                      DropdownButtonFormField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        hint: Text("Jenis Kelamin"),
                        value: _selectedGender,
                        items: genderList.map(
                          (val) {
                            return DropdownMenuItem(
                                value: val, child: Text(val));
                          },
                        ).toList(),
                        onChanged: (val) {
                          setState(
                            () {
                              _selectedGender = val;
                            },
                          );
                        },
                      ),
                      SizedBox(height: 17),

                      //ALAMAT
                      TextField(
                        controller: alamat,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: "Alamat",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),

              //BUTTON TAMBAHKAN ANGGOTA
              RaisedButton(
                child: Text("TAMBAHKAN",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 12,
                        color: Colors.white)),
                color: Colors.blueAccent,
                padding: EdgeInsets.fromLTRB(50, 13, 50, 13),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  if (nama.text.isEmpty ||
                      kelas.text.isEmpty ||
                      telp.text.isEmpty ||
                      thnAngkatan.text.isEmpty ||
                      alamat.text.isEmpty ||
                      _selectedGender == null) {
                    Toast.show(
                      "Semua data wajib diisi",
                      context,
                      duration: 2,
                      backgroundColor:
                          Colors.redAccent.shade700.withOpacity(0.7),
                      gravity: Toast.CENTER,
                    );
                  } else {
                    String gender = _selectedGender.substring(0, 1);
                    addMember(
                      id: idGenerator(
                          kelas: kelas.text,
                          thnAngkatan: thnAngkatan.text,
                          idCounter: idCounter.toString()),
                      nama: nama.text,
                      kelas: kelas.text,
                      telp: telp.text,
                      alamat: alamat.text,
                      gender: gender,
                    ).then((value) {
                      idCounter++;
                      setPref();
                      clear();
                      Toast.show(
                        "Anggota berhasil ditambahkan",
                        context,
                        duration: 3,
                        backgroundColor: Colors.blueAccent,
                        gravity: Toast.BOTTOM,
                      );
                    });
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
        ),
      ),
    );
  }
}
