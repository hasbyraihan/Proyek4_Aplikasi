import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminDetailPengajuan.dart';
import 'package:flutter_helloo_world/Faq.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

enum TemplateStatus {
  BelumDiverifikasi,
  Diterima,
  PerluDirevisi,
  Pending,
}

class AdminPengajuan extends StatefulWidget {
  @override
  _AdminPengajuanState createState() => _AdminPengajuanState();
}

class _AdminPengajuanState extends State<AdminPengajuan> {
  int _selectedIndex = 2;
  Map<String, TemplateStatus> _pengajuanStatus = {};
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('pengajuan');

  Future<List<Map<String, dynamic>>> _fetchData() async {
    DatabaseEvent event = await _databaseRef.once();
    DataSnapshot snapshot = event.snapshot;
    List<Map<String, dynamic>> dataList = [];
    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, value) {
        Map<String, dynamic> item = {};
        value.forEach((k, v) {
          item[k.toString()] = v;
        });
        item['id'] = key.toString();
        String status = item['statuspengajuan'];
        TemplateStatus templateStatus = TemplateStatus.values.firstWhere(
            (e) => e.toString() == 'TemplateStatus.' + status,
            orElse: () => TemplateStatus.BelumDiverifikasi);
        _pengajuanStatus[key.toString()] = templateStatus;
        dataList.add(item);
      });
    }
    return dataList;
  }

  Future<void> _updateStatus(String id, TemplateStatus status) async {
    await _databaseRef.child(id).update({
      'statuspengajuan': status.toString().split('.').last,
    });
  }

  void _onStatusChanged(String id, TemplateStatus? status) {
    setState(() {
      _pengajuanStatus[id] = status!;
    });
    if (status != null) {
      _updateStatus(id, status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC5E0CD),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.question_answer_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FAQ()),
            ); // Fungsi untuk menu FAQ
          },
        ),
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            List<Map<String, dynamic>> data = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> item = data[index];
                return CustomContainer(
                  color: _getColorForStatus(_pengajuanStatus[item['id']]!),
                  text: item['namaProgram'] ?? 'Unknown',
                  topLeftText: item['perguruanTinggi'] ?? 'Unknown',
                  additionalText: item['rw'] ?? 'Unknown',
                  TanggalText: item['tanggalAwal'] ?? 'Unknown',
                  TahunText: item['tanggalSelesai'] ?? 'Unknown',
                  Link: '',
                  logoPath: 'assets/images/logopolban.png',
                  templateStatus: _pengajuanStatus[item['id']],
                  onStatusChanged: (status) {
                    _onStatusChanged(item['id'], status);
                  },
                  pengajuanId: item['id'],
                );
              },
            );
          }
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

  Color _getColorForStatus(TemplateStatus status) {
    switch (status) {
      case TemplateStatus.BelumDiverifikasi:
        return Colors.grey;
      case TemplateStatus.Diterima:
        return Colors.green;
      case TemplateStatus.PerluDirevisi:
        return Colors.red;
      case TemplateStatus.Pending:
        return Colors.orange;
    }
  }
}

class CustomContainer extends StatelessWidget {
  final Color color;
  final String text;
  final String topLeftText;
  final String additionalText;
  final String TanggalText;
  final String TahunText;
  final String Link;
  final String logoPath;
  final TemplateStatus? templateStatus;
  final ValueChanged<TemplateStatus?> onStatusChanged;
  final String pengajuanId; // Add pengajuan ID

  const CustomContainer({
    Key? key,
    required this.color,
    required this.text,
    required this.topLeftText,
    required this.additionalText,
    required this.TanggalText,
    required this.TahunText,
    required this.Link,
    required this.logoPath,
    required this.templateStatus,
    required this.onStatusChanged,
    required this.pengajuanId, // Initialize pengajuan ID
  }) : super(key: key);

  final double _width = 200; // Atur lebar container di sini
  final double _height = 170; // Atur tinggi container di sini

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 17, // Padding dari sisi kiri
            top: 36, // Padding dari atas

            child: Image.asset(
              // Menambahkan gambar logo
              logoPath,
              width: 70, // Ukuran gambar logo
              height: 70,
            ),
          ),
          Positioned(
            left: (_width) /
                2, // Menempatkan teks di tengah horizontal berdasarkan lebar container dan lebar gambar logo
            top: 12, // Padding dari atas
            child: Align(
              alignment: Alignment
                  .center, // Menyatukan teks ke tengah horizontal dari container
              child: Text(
                topLeftText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            left: (_width) /
                2, // Menempatkan teks di tengah horizontal berdasarkan lebar container dan lebar gambar logo
            top: 12 +
                20 +
                8, // Padding dari atas + tinggi teks topLeftText + padding tambahan
            child: Align(
              alignment: Alignment
                  .center, // Menyatukan teks ke tengah horizontal dari container
              child: Text(
                '"' + text + '"',
                style: TextStyle(
                  color: Color.fromARGB(255, 89, 255, 0),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            left: (_width) / 2,
            top: 12 + 20 + 8 + 20 + 8 + 18 + 8,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Lokasi : ' + additionalText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            left: (_width) / 2,
            top: 12 + 20 + 8 + 20 + 8,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Tanggal : ' + TanggalText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            left: (_width) + 45,
            top: 12 + 20 + 8 + 20 + 8 + 18 + 8,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Tahun : ' + TahunText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 120,
            child: DropdownButton<TemplateStatus>(
              value: templateStatus,
              onChanged: (status) => onStatusChanged(status),
              items: [
                DropdownMenuItem(
                  value: TemplateStatus.BelumDiverifikasi,
                  child: Text('Belum Diverifikasi'),
                ),
                DropdownMenuItem(
                  value: TemplateStatus.Diterima,
                  child: Text('Diterima'),
                ),
                DropdownMenuItem(
                  value: TemplateStatus.PerluDirevisi,
                  child: Text('Perlu Direvisi'),
                ),
                DropdownMenuItem(
                  value: TemplateStatus.Pending,
                  child: Text('Pending'),
                ),
              ],
            ),
          ),
          Positioned(
            left: (_width),
            top: 130,
            child: GestureDetector(
              onTap: () {
                // Navigasi ke halaman lain
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AdminDetailPengajuan(), // Pass the pengajuan ID
                  ),
                );
              },
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Detail Pengajuan >',
                  style: TextStyle(
                    color: Color.fromARGB(255, 167, 235, 111),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
