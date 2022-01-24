import "dart:convert";
import "dart:async";
import "package:http/http.dart" as http;
import "package:library_app/API.dart";

Future<List<EmployeeData>> fetchEmployee() async {
  final response = await http.get(Uri.parse("${API.showPetugas}"));
  List? jsonResponse = json.decode(response.body);
  if (response.statusCode == 200) {
    return jsonResponse!.map((e) => EmployeeData.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load Employee Data");
  }
}

Future<List<EmployeeData>> login(
    {required String id, required String pass}) async {
  final response = await http
      .post(Uri.parse("${API.login}"), body: {"id": id, "password": pass});
  List? jsonResponse = json.decode(response.body);
  if (response.statusCode == 200) {
    return jsonResponse!.map((e) => EmployeeData.fromJson(e)).toList();
  } else {
    throw Exception("User not found");
  }
}

class EmployeeData {
  final String id;
  final String password;
  final String nama;
  final String jabatan;
  final String telp;
  final String alamat;
  final String gender;

  EmployeeData({
    required this.id,
    required this.password,
    required this.nama,
    required this.jabatan,
    required this.telp,
    required this.alamat,
    required this.gender,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) => EmployeeData(
        id: json["id"],
        password: json["password"],
        nama: json["nama"],
        jabatan: json["jabatan"],
        telp: json["telp"],
        alamat: json["alamat"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "password": password,
        "nama": nama,
        "jabatan": jabatan,
        "telp": telp,
        "alamat": alamat,
        "gender": gender,
      };
}
