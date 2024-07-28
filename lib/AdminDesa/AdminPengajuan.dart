import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminDetailPengajuan.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

enum TemplateStatus {
  BelumDiverifikasi,
  Diterima,
  PerluDirevisi,
  Pending,
  Selesai,
  Selesai_Direview,
}

class AdminPengajuan extends StatefulWidget {
  @override
  _AdminPengajuanState createState() => _AdminPengajuanState();
}

class _AdminPengajuanState extends State<AdminPengajuan> {
  int _selectedIndex = 1;
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
        if (value['statuspengajuan'] != 'Diterima' &&
            value['statuspengajuan'] != 'Selesai' &&
            value['statuspengajuan'] != 'Selesai_Direview') {
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
      if (status == TemplateStatus.PerluDirevisi) {
        _showRevisiDialog(id);
      } else {
        _updateStatus(id, status);
      }
    }
  }

  void _showRevisiDialog(String id) {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Masukkan keterangan revisi"),
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                String keterangan = _controller.text;
                if (keterangan.isNotEmpty) {
                  _updateStatusWithRevisi(
                      id, TemplateStatus.PerluDirevisi, keterangan);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateStatusWithRevisi(
      String id, TemplateStatus status, String keterangan) async {
    await _databaseRef.child(id).update({
      'statuspengajuan': status.toString().split('.').last,
      'keteranganRevisi': keterangan,
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
                  Link: '',
                  logoPath: '',
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
        return Colors.lightGreen;
      case TemplateStatus.PerluDirevisi:
        return Colors.redAccent;
      case TemplateStatus.Pending:
        return Color.fromARGB(255, 255, 187, 85);
      case TemplateStatus.Selesai:
        return Color.fromARGB(255, 105, 107, 255);
      case TemplateStatus.Selesai_Direview:
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
  final String Link;
  final String logoPath;
  final TemplateStatus? templateStatus;
  final ValueChanged<TemplateStatus?> onStatusChanged;
  final String pengajuanId;

  const CustomContainer({
    Key? key,
    required this.color,
    required this.text,
    required this.topLeftText,
    required this.additionalText,
    required this.TanggalAwal,
    required this.TanggalSelesai,
    required this.Link,
    required this.logoPath,
    required this.templateStatus,
    required this.onStatusChanged,
    required this.pengajuanId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              topLeftText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              '"$text"',
              style: TextStyle(
                color: Color.fromARGB(255, 89, 255, 0),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              'Lokasi : $additionalText',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              'Tanggal : $TanggalAwal - $TanggalSelesai',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<TemplateStatus>(
                value: templateStatus,
                onChanged: onStatusChanged,
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
                    'Detail Selengkapnya',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
