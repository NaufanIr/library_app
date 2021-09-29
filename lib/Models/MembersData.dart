import "dart:convert";
import "dart:async";
import "package:http/http.dart" as http;
import "package:library_app/API.dart";

Future<List<MembersData>> fetchMembers() async {
  final response = await http.get(Uri.parse("${API.showAnggota}"));
  List? jsonResponse = json.decode(response.body);
  if (response.statusCode == 200) {
    return jsonResponse!.map((e) => MembersData.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load Members Data");
  }
}

Future<List<MembersData>> fetchMemberById({required String? id}) async {
  var bookID = {'id': id};
  final response = await http.post(Uri.parse("${API.showAnggotaById}"),
      body: json.encode(bookID));
  List? jsonResponse = json.decode(response.body);
  if (response.statusCode == 200) {
    return jsonResponse!.map((e) => MembersData.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load Members Data");
  }
}

Future<String> addMember({
  required String id,
  required String nama,
  required String kelas,
  required String telp,
  required String alamat,
  required String gender,
}) async {
  MembersData membersData = MembersData(
    id: id,
    nama: nama,
    kelas: kelas,
    telp: telp,
    alamat: alamat,
    gender: gender,
  );
  final response = await http.post(Uri.parse("${API.addAnggota}"),
      body: membersData.toJson());
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return "Gagal menambahkan anggota kedalam server";
  }
}

Future<String> updtMember({
  required String? id,
  required String nama,
  required String kelas,
  required String telp,
  required String alamat,
  required String? gender,
}) async {
  MembersData membersData = MembersData(
    id: id,
    nama: nama,
    kelas: kelas,
    telp: telp,
    alamat: alamat,
    gender: gender,
  );
  final response = await http.post(Uri.parse("${API.updtAnggota}"),
      body: membersData.toJson());
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return "Gagal menyimpan perubahan data anggota kedalam server";
  }
}

class MembersData {
  final String? id;
  final String? nama;
  final String? kelas;
  final String? telp;
  final String? alamat;
  final String? gender;

  MembersData({
    required this.id,
    required this.nama,
    required this.kelas,
    required this.telp,
    required this.alamat,
    required this.gender,
  });

  factory MembersData.fromJson(Map<String, dynamic> json) => MembersData(
        id: json["id"],
        nama: json["nama"],
        kelas: json["kelas"],
        telp: json["telp"],
        alamat: json["alamat"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "kelas": kelas,
        "telp": telp,
        "alamat": alamat,
        "gender": gender,
      };
}
