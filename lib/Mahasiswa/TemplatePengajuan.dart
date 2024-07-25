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

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }

      var manageStatus = await Permission.manageExternalStorage.status;
      if (!manageStatus.isGranted) {
        manageStatus = await Permission.manageExternalStorage.request();
      }

      if (status.isGranted && manageStatus.isGranted) {
        print('Permissions granted');
      } else {
        print('Permissions denied');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
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

  final double _width = 207;
  final double _height = 100;

  Future<bool> checkAndRequestStoragePermission() async {
    if (Platform.isAndroid) {
      var storageStatus = await Permission.storage.status;
      var manageStatus = await Permission.manageExternalStorage.status;

      if (!storageStatus.isGranted) {
        storageStatus = await Permission.storage.request();
      }

      if (!manageStatus.isGranted) {
        manageStatus = await Permission.manageExternalStorage.request();
      }

      return storageStatus.isGranted && manageStatus.isGranted;
    } else {
      return true;
    }
  }

  Future<void> checkPermission(BuildContext context) async {
    if (await checkAndRequestStoragePermission()) {
      downloadFile(context, url, text + ".pdf");
    } else {
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
      var dir = await getExternalStorageDirectory();
      if (dir == null) {
        throw Exception("Could not access external storage directory");
      }

      String newPath = "";
      List<String> paths = dir.path.split("/");
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
            content: Text("File has been downloaded to ${dir?.path}/$fileName"),
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
    return GestureDetector(
      onTap: () => checkPermission(context),
      child: Container(
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
              left: _width + 90,
              top: _height / 2 - 30,
              child: Icon(
                icon,
                size: 60,
                color: Color.fromARGB(255, 16, 80, 8),
              ),
            ),
            Positioned(
              left: _width / 4 - 20,
              top: _height / 2 - 15,
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
