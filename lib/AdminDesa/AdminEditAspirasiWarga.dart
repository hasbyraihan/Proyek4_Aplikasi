import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class AdminEditAspirasiWarga extends StatefulWidget {
  final String aspirasiKey; // Tambahkan parameter aspirasiKey

  // Constructor yang menerima aspirasiKey
  AdminEditAspirasiWarga({required this.aspirasiKey});

  @override
  _AdminEditAspirasiWargaState createState() => _AdminEditAspirasiWargaState();
}

class _AdminEditAspirasiWargaState extends State<AdminEditAspirasiWarga> {
  int _selectedIndex = 0;
  String _selectedTopik = 'Pengaduan'; // Default value
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child('aspirasi-warga');

  TextEditingController _topikController = TextEditingController();
  TextEditingController _judulController = TextEditingController();
  TextEditingController _detailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAspirasiData(); // Ambil data aspirasi ketika screen diinisialisasi
  }

  // Fungsi untuk mengambil data aspirasi berdasarkan key dan mengisi TextField
  void _fetchAspirasiData() {
    dbRef.child(widget.aspirasiKey).once().then((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          _topikController.text = data['Topik'] ?? '';
          _judulController.text = data['Judul'] ?? '';
          _detailController.text = data['Detail'] ?? '';
        });
      } else {
        // Data tidak ditemukan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data aspirasi tidak ditemukan')),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data aspirasi: $error')),
      );
    });
  }

  // Fungsi untuk menyimpan perubahan aspirasi ke Firebase
  void _saveAspirasi() {
    Map<String, dynamic> updatedData = {
      'Topik': _topikController.text,
      'Judul': _judulController.text,
      'Detail': _detailController.text,
    };

    dbRef.child(widget.aspirasiKey).update(updatedData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aspirasi berhasil diperbarui')),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya setelah update
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui aspirasi: $error')),
      );
    });
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
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedTopik,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTopik = newValue!;
                });
              },
              items: ['Pengaduan', 'Saran']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Topik Aspirasi',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // TextField untuk judul aspirasi
            TextField(
              controller: _judulController,
              decoration: InputDecoration(
                labelText: 'Judul Aspirasi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            // TextField untuk detail aspirasi
            TextField(
              controller: _detailController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Detail Aspirasi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 32),
            // Tombol Simpan
            ElevatedButton.icon(
              onPressed: _saveAspirasi,
              icon: Icon(Icons.save),
              label: Text('Simpan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7CB083),
                minimumSize: Size(double.infinity, 48), // Full width
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
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
}
