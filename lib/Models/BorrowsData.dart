import "dart:convert";
import "dart:async";
import "package:http/http.dart" as http;
import "package:library_app/API.dart";

Future<List<BorrowsData>> fetchBorrows() async {
  final response = await http.get(Uri.parse("${API.showPeminjaman}"));
  List? jsonResponse = json.decode(response.body);
  if (response.statusCode == 200) {
    return jsonResponse!.map((e) => BorrowsData.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load Books Data");
  }
}

Future<List<BorrowsData>> fetchBorrowById({required String? id}) async {
  var borrowID = {"id": id};
  final response = await http.post(Uri.parse("${API.showPeminjamanByID}"),
      body: json.encode(borrowID));
  List? jsonResponse = json.decode(response.body);
  if (response.statusCode == 200) {
    return jsonResponse!.map((e) => BorrowsData.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load Books Data");
  }
}

Future<String> addBorrow({
  required String? id,
  required String idAnggota,
  required String? idBuku,
  required String tanggal,
  required String durasi,
}) async {
  BorrowsData borrowsData = BorrowsData(
    id: id,
    idAnggota: idAnggota,
    idBuku: idBuku,
    tanggal: tanggal,
    durasi: durasi,
  );
  final response = await http.post(Uri.parse("${API.addPeminjaman}"),
      body: borrowsData.toJson());
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return "Gagal menambahkan data peminjaman buku kedalam server";
  }
}

class BorrowsData {
  String? id;
  String? idAnggota;
  String? idBuku;
  String? tanggal;
  String? durasi;
  String? exist;
  String? judul;
  String? nama;

  BorrowsData(
      {this.id,
      this.idAnggota,
      this.idBuku,
      this.tanggal,
      this.durasi,
      this.exist,
      this.judul,
      this.nama});

  factory BorrowsData.fromJson(Map<String, dynamic> json) => BorrowsData(
        id: json["id"],
        idAnggota: json["id_anggota"],
        idBuku: json["id_buku"],
        tanggal: json["tanggal"],
        durasi: json["durasi"],
        exist: json["exist"],
        judul: json["judul"],
        nama: json["nama"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_anggota": idAnggota,
        "id_buku": idBuku,
        "tanggal": tanggal,
        "durasi": durasi,
      };
}
