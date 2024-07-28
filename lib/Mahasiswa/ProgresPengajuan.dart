import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminDetailPengajuan.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:flutter_helloo_world/Mahasiswa/EditPengajuan.dart';
import 'package:flutter_helloo_world/Mahasiswa/HasilPengabdian.dart';

enum TemplateStatus {
  BelumDiverifikasi,
  Diterima,
  PerluDirevisi,
  Pending,
}

class ProgresPengajuan extends StatefulWidget {
  @override
  _ProgresPengajuanState createState() => _ProgresPengajuanState();
}

class _ProgresPengajuanState extends State<ProgresPengajuan> {
  int _selectedIndex = 1;
  Map<String, TemplateStatus> _pengajuanStatus = {};
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('pengajuan');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = _auth.currentUser;
    setState(() {
      _uid = user?.uid;
    });
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    DatabaseEvent event = await _databaseRef.once();
    DataSnapshot snapshot = event.snapshot;
    List<Map<String, dynamic>> dataList = [];

    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, value) {
        if (value['uid'] == _uid &&
            value['statuspengajuan'] != 'Selesai' &&
            value['statuspengajuan'] != 'Selesai_Direview') {
          Map<String, dynamic> item = {};
          value.forEach((k, v) {
            item[k.toString()] = v;
          });
          item['id'] = key.toString();

          // Convert statuspengajuan to TemplateStatus
          String status = item['statuspengajuan'];
          TemplateStatus templateStatus = TemplateStatus.values.firstWhere(
              (e) => e.toString() == 'TemplateStatus.' + status,
              orElse: () => TemplateStatus.Pending // Handle unknown status case
              );
          _pengajuanStatus[key.toString()] = templateStatus;

          dataList.add(item);
        }
      });
    }

    return dataList;
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
                  TanggalAwal: item['tanggalAwal'] ?? 'Unknown',
                  TanggalSelesai: item['tanggalSelesai'] ?? 'Unknown',
                  templateStatus: _pengajuanStatus[item['id']],
                  pengajuanId: item['id'],
                  keteranganRevisi: item['keteranganRevisi'] ?? 'Unknown',
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
        return Color(0xff60ac76);
      case TemplateStatus.PerluDirevisi:
        return Colors.redAccent;
      case TemplateStatus.Pending:
        return Color.fromARGB(255, 255, 187, 85);
    }
  }
}

class CustomContainer extends StatelessWidget {
  final Color color;
  final String text;
  final String keteranganRevisi;
  final String topLeftText;
  final String additionalText;
  final String TanggalAwal;
  final String TanggalSelesai;
  final TemplateStatus? templateStatus;
  final String pengajuanId;

  const CustomContainer({
    Key? key,
    required this.color,
    required this.text,
    required this.keteranganRevisi,
    required this.topLeftText,
    required this.additionalText,
    required this.TanggalAwal,
    required this.TanggalSelesai,
    required this.templateStatus,
    required this.pengajuanId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.width;

    return Container(
      width: _width,
      height: _height * 0.7,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            topLeftText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            '"' + text + '"',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 255, 0),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Lokasi : ' + additionalText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Tanggal : ' + TanggalAwal + ' - ' + TanggalSelesai,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            templateStatus.toString().split('.').last,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          if (templateStatus != TemplateStatus.Diterima ||
              templateStatus == TemplateStatus.Diterima)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminDetailPengajuan(
                      pengajuanId: pengajuanId,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Detail Pengajuan Pengabdian',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (templateStatus == TemplateStatus.Diterima)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HasilPengabdian(
                      pengajuanId: pengajuanId,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Upload Hasil Pengabdian',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          SizedBox(height: 8),
          if (templateStatus == TemplateStatus.PerluDirevisi) ...[
            Text(
              '"' + keteranganRevisi + '"',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPengajuan(
                      pengajuanId: pengajuanId,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Edit Pengajuan Pengabdian',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
