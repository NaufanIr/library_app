import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/API.dart';

Future<List<BooksData>> fetchBooks() async {
  final response = await http.get("${API.showBuku}");
  List jsonResponse = json.decode(response.body);
  if (response.statusCode == 200) {
    return jsonResponse.map((e) => BooksData.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load Books Data");
  }
}

Future<List<BooksData>> fetchBookById({@required String id}) async {
  var bookID = {'id': id};
  final response =
      await http.post("${API.showBukuById}", body: json.encode(bookID));
  List jsonResponse = json.decode(response.body);
  if (response.statusCode == 200) {
    return jsonResponse.map((e) => BooksData.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load Books Data");
  }
}

Future<String> delBook({@required String id}) async {
  BooksData booksData = BooksData(id: id);
  final response =
      await http.post("${API.delBuku}", body: booksData.toJsonDel());
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return "Gagal menghapus data buku";
  }
}

Future<String> addBook({
  @required String id,
  @required String judul,
  @required String pengarang,
  @required String penerbit,
  @required String tahun,
  @required String jumlah,
}) async {
  BooksData booksData = BooksData(
    id: id,
    judul: judul,
    pengarang: pengarang,
    penerbit: penerbit,
    tahun: tahun,
    jumlah: jumlah,
  );
  final response = await http.post("${API.addBuku}", body: booksData.toJson());
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return "Gagal menambahkan buku kedalam server";
  }
}

Future<String> updateBook({
  @required String id,
  @required String judul,
  @required String pengarang,
  @required String penerbit,
  @required String tahun,
  @required String jumlah,
}) async {
  BooksData booksData = BooksData(
    id: id,
    judul: judul,
    pengarang: pengarang,
    penerbit: penerbit,
    tahun: tahun,
    jumlah: jumlah,
  );
  final response = await http.post("${API.updtBuku}", body: booksData.toJson());
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return "Gagal menyimpan perubahan data buku kedalam server";
  }
}

class BooksData {
  String id;
  String judul;
  String pengarang;
  String penerbit;
  String tahun;
  String jumlah;

  BooksData({
    this.id,
    this.judul,
    this.pengarang,
    this.penerbit,
    this.tahun,
    this.jumlah,
  });

  factory BooksData.fromJson(Map<String, dynamic> json) => BooksData(
        id: json["id"],
        judul: json["judul"],
        pengarang: json["pengarang"],
        penerbit: json["penerbit"],
        tahun: json["tahun"],
        jumlah: json["jumlah"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "judul": judul,
        "pengarang": pengarang,
        "penerbit": penerbit,
        "tahun": tahun,
        "jumlah": jumlah,
      };

  Map<String, dynamic> toJsonDel() => {
        "id": id,
      };
}
