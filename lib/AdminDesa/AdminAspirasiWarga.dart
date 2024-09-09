import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminTambahAspirasiWarga.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminEditAspirasiWarga.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class AdminAspirasiWarga extends StatefulWidget {
  @override
  _AdminAspirasiWargaState createState() => _AdminAspirasiWargaState();
}

class _AdminAspirasiWargaState extends State<AdminAspirasiWarga> {
  int _selectedIndex = 0; // Deklarasi dan inisialisasi _selectedIndex
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child('aspirasi-warga');
  List<Map<String, dynamic>> aspirasiList = [];

  @override
  void initState() {
    super.initState();
    _fetchAspirasi(); // Fetch data when screen is initialized
  }

  // Fungsi untuk mengambil data dari Firebase
  void _fetchAspirasi() {
    dbRef.onValue.listen((event) {
      final Map<dynamic, dynamic>? data =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          aspirasiList = data.entries.map((e) {
            return {
              'key': e.key,
              'topik': e.value['Topik'],
              'judul': e.value['Judul'],
            };
          }).toList();
        });
      }
    });
  }

  // Fungsi untuk menghapus aspirasi dari Firebase
  void _deleteAspirasi(String key) {
    dbRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aspirasi berhasil dihapus')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus aspirasi: $error')),
      );
    });
  }

  // Fungsi untuk mengedit aspirasi
  void editAspirasi(String key) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AdminEditAspirasiWarga(aspirasiKey: key), // Kirim data key
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC5E0CD),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Image.asset(
              'assets/images/logo.png',
              width: 54,
              height: 52,
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFE9F0EB),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: aspirasiList.isEmpty
            ? Center(child: Text('Tidak ada aspirasi.'))
            : ListView.builder(
                itemCount: aspirasiList.length,
                itemBuilder: (context, index) {
                  final aspirasi = aspirasiList[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF7CB083),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display Topik
                        Text(
                          aspirasi['topik'] ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Display Judul
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFF2F5F1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Judul aspirasi
                              Text(aspirasi['judul'] ?? ''),
                              // Icon edit dan hapus
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.grey),
                                    onPressed: () {
                                      // Panggil fungsi edit dengan membawa key atau data aspirasi yang relevan
                                      editAspirasi(aspirasi['key']);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteDialog(aspirasi[
                                          'key']); // Tampilkan dialog konfirmasi
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF7CB083),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminTambahAspirasiWarga()),
          );
        },
      ),
      bottomNavigationBar: BarNavigasi.NavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  void _showDeleteDialog(String key) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus aspirasi ini?'),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () {
                _deleteAspirasi(key); // Hapus aspirasi
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
  }
}
