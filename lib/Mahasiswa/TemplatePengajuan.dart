import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class TemplatePengajuan extends StatefulWidget {
  @override
  _TemplatePengajuanState createState() => _TemplatePengajuanState();
}

class TemplatePengajuanItem {
  final String name;
  final String url;

  TemplatePengajuanItem({required this.name, required this.url});
}

class _TemplatePengajuanState extends State<TemplatePengajuan> {
  Future<List<TemplatePengajuanItem>> fetchTemplates() async {
    List<TemplatePengajuanItem> templates = [];
    try {
      final userRef = FirebaseDatabase.instance.ref('template-doc');
      final snapshot = await userRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          final name = value['name'] ?? '';
          final url = value['url'] ?? '';
          templates.add(TemplatePengajuanItem(name: name, url: url));
        });
      }
    } catch (e) {
      print('Error fetching templates: $e');
    }
    return templates;
  }

  @override
  void initState() {
    super.initState();
    // requestPermissions();
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
      body: FutureBuilder<List<TemplatePengajuanItem>>(
        future: fetchTemplates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text('Error fetching templates'),
            );
          } else {
            final templates = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                return CustomContainer(
                  color: Color(0xFF60AD77),
                  text: templates[index].name,
                  url: templates[index].url,
                  icon: Icons.file_download,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final Color color;
  final String text;
  final String url;
  final IconData icon;

  const CustomContainer({
    Key? key,
    required this.color,
    required this.text,
    required this.url,
    required this.icon,
  }) : super(key: key);

  Future<bool> checkAndRequestStoragePermission() async {
    if (Platform.isAndroid) {
      // Untuk Android 13 (API level 33) ke atas
      if (Platform.operatingSystemVersion.contains('33') ||
          Platform.version.startsWith('33')) {
        // Tidak perlu permission untuk file media (gambar, audio, video)
        return true;
      } else {
        // Untuk Android 12 ke bawah (SDK 32 dan sebelumnya)
        var storageStatus = await Permission.storage.status;
        if (!storageStatus.isGranted) {
          storageStatus = await Permission.storage.request();
        }
        return true;
      }
    } else {
      return true;
    }
  }

  Future<void> checkPermission(BuildContext context) async {
    bool permissionGranted = await checkAndRequestStoragePermission();
    if (permissionGranted) {
      downloadFile(context, url, text + ".pdf");
    } else {
      // Tampilkan dialog jika izin belum diberikan (untuk versi Android yang lebih lama)
      showPermissionDialog(context);
    }
  }

  void showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Storage Permission"),
          content: const Text(
              "Storage permission is required to download files. Would you like to go to app settings to grant the permission?"),
          actions: <Widget>[
            TextButton(
                child: const Text('No thanks'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
                child: const Text('Ok'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await openAppSettings();
                })
          ],
        );
      },
    );
  }

  Future<void> downloadFile(
      BuildContext context, String url, String fileName) async {
    try {
      Dio dio = Dio();

      // Mendapatkan direktori penyimpanan dokumen aplikasi
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      // Download file ke direktori dokumen aplikasi
      await dio.download(url, filePath);
      print("File downloaded to $filePath");

      // Menampilkan dialog sukses
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Download Successful"),
            content: Text("File has been downloaded to $filePath"),
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
    } catch (e) {
      print("Error downloading file: $e");

      // Menampilkan dialog gagal download
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
    // Menggunakan MediaQuery untuk membuat tampilan lebih responsif
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double containerWidth = screenWidth * 0.8; // 80% dari lebar layar
    double containerHeight = screenHeight * 0.12; // 12% dari tinggi layar

    return GestureDetector(
      onTap: () => checkPermission(context),
      child: Container(
        width: containerWidth,
        height: containerHeight,
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 20, // Ikon akan selalu di sisi kanan
              top: containerHeight / 2 - 30,
              child: Icon(
                icon,
                size: 60,
                color: Color.fromARGB(255, 16, 80, 8),
              ),
            ),
            Positioned(
              left: 20, // Teks berada di kiri
              top: containerHeight / 2 - 15,
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
