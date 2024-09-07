import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart' as BarNavigasi;

class AdminTambahAspirasiWarga extends StatefulWidget {
  @override
  _AdminTambahAspirasiWargaState createState() => _AdminTambahAspirasiWargaState();
}

class _AdminTambahAspirasiWargaState extends State<AdminTambahAspirasiWarga> {
  int _selectedIndex = 0; // Deklarasi dan inisialisasi _selectedIndex
  String? selectedTopic;
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('aspirasi-warga');

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for selecting topik
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFF2F5F1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedTopic,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  border: InputBorder.none,
                  hintText: 'Topik Aspirasi',
                ),
                items: ['Pengaduan', 'Saran'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedTopic = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: 16),

            // TextFormField for Judul Aspirasi
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFF2F5F1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: _judulController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  border: InputBorder.none,
                  hintText: 'Judul Aspirasi',
                ),
              ),
            ),
            SizedBox(height: 16),

            // TextFormField for Detail Aspirasi
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFF2F5F1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: _detailController,
                minLines: 3, // Ukuran awal tetap (misal: 3 baris)
                maxLines: null, // Menyesuaikan ukuran secara fleksibel saat teks bertambah
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  border: InputBorder.none,
                  hintText: 'Detail Aspirasi',
                ),
              ),
            ),
            SizedBox(height: 32),

            // Simpan Button
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7CB083),
                  minimumSize: Size(double.infinity, 50), // Full-width button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _saveAspirasi, // Panggil fungsi simpan
                icon: Icon(Icons.save, color: Colors.white),
                label: Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white),
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

  // Fungsi untuk menyimpan aspirasi ke Firebase
  void _saveAspirasi() {
    if (selectedTopic == null || _judulController.text.isEmpty || _detailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap isi semua kolom!')),
      );
      return;
    }

    // Dapatkan key untuk tiap aspirasi
    String key = dbRef.push().key ?? '';

    // Data yang akan dikirim ke Firebase
    Map<String, String> aspirasiData = {
      'Topik': selectedTopic!,
      'Judul': _judulController.text,
      'Detail': _detailController.text,
    };

    // Simpan ke Firebase
    dbRef.child(key).set(aspirasiData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aspirasi berhasil disimpan!')),
      );
      // Reset form setelah data disimpan
      setState(() {
        selectedTopic = null;
        _judulController.clear();
        _detailController.clear();
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan aspirasi: $error')),
      );
    });
  }
}
