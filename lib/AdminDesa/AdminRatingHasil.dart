import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminDaftarRating.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:flutter_helloo_world/Models/pengajuan.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AdminRatingHasil extends StatefulWidget {
  final String pengajuanId;

  AdminRatingHasil({required this.pengajuanId});

  @override
  _AdminRatingHasilState createState() => _AdminRatingHasilState();
}

class _AdminRatingHasilState extends State<AdminRatingHasil> {
  int _selectedIndex = 1;
  int _rating = 0;
  String _evaluasi = ''; // New property to store evaluation
  late DatabaseReference _fectchdatabase;
  final DatabaseReference _setdatabase =
      FirebaseDatabase.instance.ref().child("evaluasi");
  final DatabaseReference _updatedatabase =
      FirebaseDatabase.instance.ref().child("pengajuan");
  Pengajuan? _pengajuanData;

  @override
  void initState() {
    super.initState();

    _fetchPengajuanData();
  }

  void _fetchPengajuanData() async {
    try {
      _fectchdatabase = FirebaseDatabase.instance
          .ref()
          .child('pengajuan')
          .child(widget.pengajuanId);
      DatabaseEvent event = await _fectchdatabase.once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          _pengajuanData = Pengajuan.fromMap(
              Map<String, dynamic>.from(snapshot.value as Map));
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _onDownloadPressed(String fileName) async {
    try {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('dokumen-pendukung')
          .child(widget.pengajuanId)
          .child(fileName);

      String url = await ref.getDownloadURL();
      await downloadFile(context, url, fileName);
    } catch (e) {
      print('Error during download: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during download: $e')),
      );
    }
  }

  Future<void> downloadFile(
      BuildContext context, String url, String fileName) async {
    try {
      if (await Permission.storage.request().isGranted) {
        Dio dio = Dio();
        var dir = await getExternalStorageDirectory();
        String newPath = "";
        List<String> paths = dir!.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/Download";
        dir = Directory(newPath);

        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }

        await dio.download(url, "${dir.path}/$fileName");
        print("File downloaded to ${dir.path}/$fileName");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Download Successful"),
              content:
                  Text("File has been downloaded to ${dir?.path}/$fileName"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print("Permission denied");
      }
    } catch (e) {
      print("Error downloading file: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Download Failed"),
            content: Text("Error downloading file: $e"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _saveEvaluasiAndRating() async {
    try {
      await _setdatabase.child(widget.pengajuanId).set({
        'rating': _rating,
        'evaluasi': _evaluasi,
      });

      await _updatedatabase.child(widget.pengajuanId).update({
        'statuspengajuan': "Selesai_Direview",
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Evaluasi dan Rating berhasil disimpan'),
        ),
      );

      // Navigate to the dashboard page and remove all previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AdminDaftarRating()),
        (Route<dynamic> route) => false,
      );
      print('Evaluasi dan Rating berhasil disimpan');
    } catch (e) {
      print('Error saving evaluasi and rating: $e');
    }
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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          SizedBox(height: 20),
          _pengajuanData != null
              ? CustomContainer(
                  color: Color(0xFF60AD77),
                  text: _pengajuanData!.title,
                  topLeftText: _pengajuanData!.institution,
                  additionalText: _pengajuanData!.location,
                  TanggalText: _pengajuanData!.datesMulai +
                      ' - ' +
                      _pengajuanData!.datesSelesai,
                  TahunText: '',
                  lakiLaki: _pengajuanData!.lakiLaki,
                  perempuan: _pengajuanData!.perempuan,
                  totalPeserta: _pengajuanData!.totalPeserta,
                  bidangPengabdian: _pengajuanData!.bidangPengabdian,
                  hasilPengabdian: _pengajuanData!.hasilPengabdian,
                  logoPath: 'assets/images/logopolban.png',
                  rating: _rating,
                  pengajuanId: widget.pengajuanId,
                  onRatingChanged: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                  onEvaluasiChanged: (evaluasi) {
                    setState(() {
                      _evaluasi = evaluasi;
                    });
                  },
                )
              : Center(child: CircularProgressIndicator()),
          SizedBox(height: 20),
          Container(
            child: Center(
              child: _buildDownloadContainer('Dokumen Hasil Pengabdian'),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveEvaluasiAndRating,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF60AD77),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            ),
            child: Text(
              'Submit Evaluasi dan Rating',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
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

  Widget _buildDownloadContainer(String text) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () => _onDownloadPressed(text + '.pdf'),
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        width: screenWidth * 0.9,
        height: 75,
        decoration: BoxDecoration(
          color: Color(0xFF60AD77),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 30),
            Icon(
              Icons.download,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomContainer extends StatefulWidget {
  final Color color;
  final String text;
  final String topLeftText;
  final String additionalText;
  final String TanggalText;
  final String TahunText;
  final String logoPath;
  final int rating;
  final ValueChanged<int> onRatingChanged;
  final ValueChanged<String> onEvaluasiChanged;
  final String lakiLaki;
  final String perempuan;
  final String totalPeserta;
  final String bidangPengabdian;
  final String hasilPengabdian;
  final String pengajuanId;

  const CustomContainer(
      {Key? key,
      required this.color,
      required this.text,
      required this.topLeftText,
      required this.additionalText,
      required this.TanggalText,
      required this.TahunText,
      required this.logoPath,
      required this.rating,
      required this.onRatingChanged,
      required this.onEvaluasiChanged,
      required this.lakiLaki,
      required this.perempuan,
      required this.totalPeserta,
      required this.bidangPengabdian,
      required this.hasilPengabdian,
      required this.pengajuanId})
      : super(key: key);

  @override
  _CustomContainerState createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  bool _isEditing = false;
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      widget.onEvaluasiChanged(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.9,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.topLeftText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '"' + widget.text + '"',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Lokasi : ' + widget.additionalText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Tanggal : ' + widget.TanggalText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              width: screenWidth * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Icon(
                      Icons.assured_workload,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Bidang Pengabdian : \n' + widget.bidangPengabdian,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              width: screenWidth * 0.8,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.group,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Total Peserta : ' + widget.totalPeserta + ' Orang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              width: screenWidth * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.description,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Deskripsi Hasil Pengabdian  : \n' +
                          widget.hasilPengabdian,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          _buildRatingStars(),
          SizedBox(height: 10),
          _buildEditableContainer(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildRatingStars() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.8,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            'Rating',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  widget.onRatingChanged(index + 1);
                },
                child: Icon(
                  index < widget.rating ? Icons.star : Icons.star_border,
                  color: index < widget.rating ? Colors.orange : Colors.orange,
                  size: 30,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableContainer() {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isEditing = true;
        });
      },
      child: Container(
        width: screenWidth * 0.8,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: _isEditing
            ? Column(
                children: [
                  Text(
                    'Evaluasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Divider(),
                  TextField(
                    controller: _controller,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Ketik evaluasi di sini...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                      });
                    },
                    child: Text('Simpan'),
                  ),
                ],
              )
            : Text(
                _controller.text.isEmpty
                    ? 'Ketik evaluasi di sini...'
                    : _controller.text,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
      ),
    );
  }
}
