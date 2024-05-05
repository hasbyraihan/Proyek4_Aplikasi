import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AdminDatabaseService {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref('info-desa');

  Future<void> updateDataPopulasi(
      BuildContext context, int malePopulation, int femalePopulation) async {
    try {
      await _database.child('populasi').update({
        'pria': malePopulation,
        'wanita': femalePopulation,
        'total': malePopulation + femalePopulation,
      });
      print('Data populasi berhasil diperbarui!');
      // Redirect ke halaman sebelumnya
      Navigator.pop(context);
    } catch (e) {
      print('Error saat memperbarui data populasi: $e');
      // Tambahkan penanganan error sesuai kebutuhan
    }
  }
}
