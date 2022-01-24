// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_app/Models/BorrowsData.dart';
import 'package:library_app/Widgets/CardBorrow.dart';
import 'package:library_app/main.dart';

void main() async {
  print("TEST 1");
  print("TEST 2");
  Future.delayed(Duration(seconds: 3)).then((_) => print("TEST 3"));
  //print("TEST 3");
  print("TEST 4");


  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());
  //
  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);
  //
  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();
  //
  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
}

// var denda;
// void main() async {
//   print("TEST GET DENDA");
//   await GetDenda();
//   print(GetDenda());
//   //print("Denda = Rp ${denda * -1}.000,-");
//   print("Selesai");
//
//   // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//   //   // Build our app and trigger a frame.
//   //   await tester.pumpWidget(MyApp());
//   //
//   //   // Verify that our counter starts at 0.
//   //   expect(find.text('0'), findsOneWidget);
//   //   expect(find.text('1'), findsNothing);
//   //
//   //   // Tap the '+' icon and trigger a frame.
//   //   await tester.tap(find.byIcon(Icons.add));
//   //   await tester.pump();
//   //
//   //   // Verify that our counter has incremented.
//   //   expect(find.text('0'), findsNothing);
//   //   expect(find.text('1'), findsOneWidget);
//   // });
// }

Future<int?> GetDenda() async {
  return await fetchBorrowById(id: "A210802643").then(
    (data) => CardBorrow.returnCountDown(
      year: int.parse(data[0].tanggal!.substring(0, 4)),
      month: int.parse(data[0].tanggal!.substring(5, 7)),
      day: int.parse(data[0].tanggal!.substring(8, 10)),
      durasi: int.parse(data[0].durasi!),
    ),
  );
}
