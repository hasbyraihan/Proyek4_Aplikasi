import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:flutter_helloo_world/Models/pengajuan.dart';
import 'package:path_provider/path_provider.dart'; // Add this for getting local directory
import 'dart:io';

import 'package:permission_handler/permission_handler.dart'; // Add this for file operations

class AdminDetailPengajuan extends StatefulWidget {
  final String pengajuanId;

  AdminDetailPengajuan({required this.pengajuanId});

  @override
  _AdminDetailPengajuanState createState() => _AdminDetailPengajuanState();
}

class _AdminDetailPengajuanState extends State<AdminDetailPengajuan> {
  int _selectedIndex = 1;
  late DatabaseReference _databaseReference;
  Pengajuan? _pengajuanData;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance
        .ref()
        .child('pengajuan')
        .child(widget.pengajuanId);
    _fetchPengajuanData();
  }

  void _fetchPengajuanData() async {
    try {
      DatabaseEvent event = await _databaseReference.once();
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

  @override
  Widget build(BuildContext context) {
    if (_pengajuanData == null) {
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
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
          CustomContainer(
            color: Color(0xFF60AD77),
            text: _pengajuanData!.title,
            topLeftText: _pengajuanData!.institution,
            additionalText: _pengajuanData!.location,
            datesMulai: _pengajuanData!.datesMulai,
            datesSelesai: _pengajuanData!.datesSelesai,
            lakiLaki: _pengajuanData!.lakiLaki,
            perempuan: _pengajuanData!.perempuan,
            totalPeserta: _pengajuanData!.totalPeserta,
            bidangPengabdian: _pengajuanData!.bidangPengabdian,
            logoPath: 'assets/images/logopolban.png',
          ),
          SizedBox(height: 20),
          Container(
            child: Wrap(
              spacing: 55.0,
              runSpacing: 10.0,
              children: [
                _buildDownloadContainer('Surat Izin Desa'),
                _buildDownloadContainer('Surat Izin Kecamatan'),
                _buildDownloadContainer('Surat Izin PT'),
                _buildDownloadContainer('Surat Izin Koramil'),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 110.0), // Tambahkan padding kiri
                  child: _buildDownloadContainer('Surat Izin Kapolsek'),
                ),
              ],
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
    return InkWell(
      onTap: () => _onDownloadPressed(text + '.pdf'),
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        width: 151,
        height: 75,
        decoration: BoxDecoration(
          color: Color(0xFF60AD77),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
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
            SizedBox(height: 5),
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

class CustomContainer extends StatelessWidget {
  final Color color;
  final String text;
  final String topLeftText;
  final String additionalText;
  final String datesMulai;
  final String datesSelesai;
  final String lakiLaki;
  final String perempuan;
  final String totalPeserta;
  final String bidangPengabdian;
  final String logoPath; // Menambahkan path gambar logo

  const CustomContainer({
    Key? key,
    required this.color,
    required this.text,
    required this.topLeftText,
    required this.additionalText,
    required this.datesMulai,
    required this.datesSelesai,
    required this.lakiLaki,
    required this.perempuan,
    required this.totalPeserta,
    required this.bidangPengabdian,
    required this.logoPath, // Menambahkan path gambar logo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth *
          0.9, // Mengatur lebar container menjadi 90% dari lebar layar
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(
          //       left: 17, top: 36), // Padding dari sisi kiri dan atas
          //   child: Image.asset(
          //     // Menambahkan gambar logo
          //     logoPath,
          //     width: 70, // Ukuran gambar logo
          //     height: 70,
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(top: 12),
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
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Align(
              alignment: Alignment
                  .center, // Menyatukan teks ke tengah horizontal dari container
              child: Text(
                '"' + text + '"',
                style: TextStyle(
                  color: Color.fromARGB(255, 62, 146, 17),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
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
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Tanggal : ' + datesMulai + ' - ' + datesSelesai,
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
              width: screenWidth *
                  0.8, // Mengatur lebar container menjadi 80% dari lebar layar
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
                      Icons.assured_workload,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Bidang Pengabdian : ' +
                          bidangPengabdian, // Isian teks di sini
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
              width: screenWidth *
                  0.8, // Mengatur lebar container menjadi 80% dari lebar layar
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
                      'Jumlah Total     : ' +
                          totalPeserta +
                          ' Orang', // Isian teks di sini
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: screenWidth *
                      0.4, // Mengatur lebar container menjadi 40% dari lebar layar
                  height: 102,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.person_2_sharp,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                          height: 8), // Spacer untuk jarak antara ikon dan teks
                      Center(
                        child: Text(
                          'Jumlah Laki Laki \n ' +
                              lakiLaki +
                              ' Orang', // Isian teks di sini
                          textAlign: TextAlign.center,
                          softWrap: true,
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
                Container(
                  width: screenWidth *
                      0.4, // Mengatur lebar container menjadi 40% dari lebar layar
                  height: 102,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.person_4_sharp,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                          height: 8), // Spacer untuk jarak antara ikon dan teks
                      Center(
                        child: Text(
                          'Jumlah Perempuan \n ' +
                              perempuan +
                              ' Orang', // Isian teks di sini
                          textAlign: TextAlign.center,
                          softWrap: true,
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
              ],
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 20),
          //   child: Container(
          //     width: screenWidth *
          //         0.8, // Mengatur lebar container menjadi 80% dari lebar layar
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.only(right: 10),
          //           child: Icon(
          //             Icons.description,
          //             size: 30,
          //             color: Colors.grey,
          //           ),
          //         ),
          //         Expanded(
          //           child: Text(
          //             'Tujuan Kegiatan : \naaaaaaaaaaaaaaaaaaaaa', // Isian teks di sini
          //             softWrap: true,
          //             overflow: TextOverflow
          //                 .visible, // Mengizinkan teks meluas di luar batas kontainer
          //             style: TextStyle(
          //               fontSize: 16,
          //               fontWeight: FontWeight.bold,
          //               color: Colors.grey,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(height: 20), // Spacer tambahan jika dibutuhkan
        ],
      ),
    );
  }
}
