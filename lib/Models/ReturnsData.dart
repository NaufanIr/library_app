import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:library_app/API.dart';
import "package:http/http.dart" as http;

Future<List<ReturnData>> fetchReturn() async {
  final response = await http.get(Uri.parse("${API.showKembali}"));
  List? jsonResponse = json.decode(response.body);
  if (response.statusCode == 200) {
    return jsonResponse!.map((e) => ReturnData.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load book return data");
  }
}

Future<String> addReturn({
  required String? idPeminjaman,
  required String tanggal,
  required String denda,
  required String ket,
}) async {
  ReturnData returnData = ReturnData(
    idPeminjaman: idPeminjaman,
    tanggal: tanggal,
    denda: denda,
    keterangan: ket,
  );
  final response = await http.post(Uri.parse("${API.addPengembalian}"),
      body: returnData.toJson());
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return "Gagal menambahkan anggota kedalam server";
  }
}

class ReturnData {
  final String? id;
  final String? idPeminjaman;
  final String? tanggal;
  final String? denda;
  final String? keterangan;
  final String? nama;
  final String? judul;
  final String? tglPinjam;
  final String? durasi;

  ReturnData({
    this.id,
    this.idPeminjaman,
    this.tanggal,
    this.denda,
    this.keterangan,
    this.nama,
    this.judul,
    this.tglPinjam,
    this.durasi,
  });

  factory ReturnData.fromJson(Map<String, dynamic> json) => ReturnData(
        id: json["id"],
        idPeminjaman: json["id_peminjaman"],
        tanggal: json["tanggal"],
        denda: json["denda"],
        keterangan: json["keterangan"],
        nama: json["nama"],
        judul: json["judul"],
        tglPinjam: json["tglPinjam"],
        durasi: json["durasi"],
      );

  Map<String, dynamic> toJson() => {
        "id_peminjaman": idPeminjaman,
        "tanggal": tanggal,
        "denda": denda,
        "keterangan": keterangan,
      };
}
