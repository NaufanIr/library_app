import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class PdfApi {
  static Future cetakKartu(
      {var idAnggota, var judul, var durasi, var tgl, var id}) async {
    final pdf = Document();
    final image = await rootBundle.loadString('images/logo.svg');
    final font = Font.ttf(await rootBundle.load('fonts/Montserrat-Bold.ttf'));
    pdf.addPage(
      Page(
        pageFormat: PdfPageFormat.roll80,
        build: (context) {
          double fontSize = 8;
          return Column(
            children: [
              //LOGO
              SvgImage(svg: image, height: 75, width: 75),
              SizedBox(height: 10),

              //HEADER
              Text(
                "Kartu Peminjaman",
                style: TextStyle(
                  font: font,
                  fontSize: 13.6,
                  color: PdfColor.fromInt(0xff5C549A),
                ),
              ),
              SizedBox(height: 19),

              //DETAILS
              Center(
                child: Container(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //ID ANGGOTA
                      Row(
                        children: [
                          Text(
                            "ID Anggota : ",
                            style: TextStyle(
                              font: font,
                              fontSize: fontSize,
                              color: PdfColor.fromInt(0xff5C549A),
                            ),
                          ),
                          Text(
                            "$idAnggota",
                            style: TextStyle(
                              fontSize: fontSize,
                              color: PdfColor.fromInt(0xff5C549A),
                            ),
                          ),
                        ],
                      ),

                      //JUDUL BUKU
                      Row(
                        children: [
                          Text(
                            "Buku : ",
                            style: TextStyle(
                              font: font,
                              fontSize: fontSize,
                              color: PdfColor.fromInt(0xff5C549A),
                            ),
                          ),
                          Text(
                            "$judul",
                            style: TextStyle(
                              fontSize: fontSize,
                              color: PdfColor.fromInt(0xff5C549A),
                            ),
                          ),
                        ],
                      ),

                      //DURASI PINJAM
                      Row(
                        children: [
                          Text(
                            "Durasi Pinjam : ",
                            style: TextStyle(
                              font: font,
                              fontSize: fontSize,
                              color: PdfColor.fromInt(0xff5C549A),
                            ),
                          ),
                          Text(
                            "$durasi Hari",
                            style: TextStyle(
                              fontSize: fontSize,
                              color: PdfColor.fromInt(0xff5C549A),
                            ),
                          ),
                        ],
                      ),

                      //TGL.KEMBALI
                      Row(
                        children: [
                          Text(
                            "Tgl.Kembali : ",
                            style: TextStyle(
                              font: font,
                              fontSize: fontSize,
                              color: PdfColor.fromInt(0xff5C549A),
                            ),
                          ),
                          Text(
                            "$tgl",
                            style: TextStyle(
                              fontSize: fontSize,
                              color: PdfColor.fromInt(0xff5C549A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              //ID KARTU PEMINJAMAN
              Text(
                "ID : $id",
                style: TextStyle(
                  font: font,
                  fontSize: 9,
                  color: PdfColor.fromInt(0xff5C549A),
                ),
              ),
              SizedBox(height: 5),

              //QR CODE
              BarcodeWidget(
                height: 60,
                width: 60,
                data: id,
                barcode: Barcode.qrCode(),
              ),
            ],
          );
        },
      ),
    );
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/kartu.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());
    await OpenFile.open(path);
  }
}
