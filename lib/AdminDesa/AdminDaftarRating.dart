import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminRatingHasil.dart';

import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

enum TemplateStatus {
  BelumDiverifikasi,
  Diterima,
  PerluDirevisi,
  Pending,
  Selesai,
}

class AdminDaftarRating extends StatefulWidget {
  @override
  _AdminDaftarRatingState createState() => _AdminDaftarRatingState();
}

class _AdminDaftarRatingState extends State<AdminDaftarRating> {
  int _selectedIndex = 1;
  Map<String, TemplateStatus> _pengajuanStatus = {};
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('pengajuan');

  @override
  void initState() {
    super.initState();
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    DatabaseEvent event = await _databaseRef.once();
    DataSnapshot snapshot = event.snapshot;
    List<Map<String, dynamic>> dataList = [];
    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, value) {
        if (value['statuspengajuan'] == 'Selesai') {
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
        return Colors.lightGreen;
      case TemplateStatus.PerluDirevisi:
        return Colors.redAccent;
      case TemplateStatus.Pending:
        return Color.fromARGB(255, 255, 187, 85);
      case TemplateStatus.Selesai:
        return Color(0xFF60AD77);
    }
  }
}

class CustomContainer extends StatelessWidget {
  final Color color;
  final String text;
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
    required this.topLeftText,
    required this.additionalText,
    required this.TanggalAwal,
    required this.TanggalSelesai,
    required this.templateStatus,
    required this.pengajuanId,
  }) : super(key: key);

  final double _width = 200;
  final double _height = 270;

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
              color: Color.fromARGB(255, 89, 255, 0),
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
          SizedBox(height: 16),
          Text(
            templateStatus.toString().split('.').last,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          if (templateStatus == TemplateStatus.Selesai)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AdminRatingHasil(pengajuanId: pengajuanId),
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
                  'Berikan Rating & Evaluasi',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
