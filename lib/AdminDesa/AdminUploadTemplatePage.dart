import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class AdminUploadTemplatePage extends StatefulWidget {
  @override
  _AdminUploadTemplatePageState createState() =>
      _AdminUploadTemplatePageState();
}

class _AdminUploadTemplatePageState extends State<AdminUploadTemplatePage> {
  List<String> templates = [
    'Surat Izin Kapolsek',
    'Surat Izin Koramil',
    'Surat Izin PT',
    'Surat Izin Kecamatan',
    'Surat Izin Desa',
    'Dokumen Hasil Pengabdian'
  ];

  Map<String, File?> templateFiles = {};

  Future<void> _pickFile(String templateName) async {
    try {
      final pickedFile = await FilePicker.platform.pickFiles();
      if (pickedFile != null) {
        final filePath = pickedFile.files.single.path!;
        final file = File(filePath);

        // Simpan file ke direktori lokal aplikasi
        final directory = await getApplicationDocumentsDirectory();
        final localFilePath = '${directory.path}/${file.uri.pathSegments.last}';
        final localFile = File(localFilePath);

        await file.copy(localFilePath);

        setState(() {
          templateFiles[templateName] = localFile;
        });

        _uploadFileToFirebase(templateName, localFile);
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick file: $e')),
      );
    }
  }

  Future<void> _uploadFileToFirebase(String templateName, File file) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('template-doc/$templateName');
      UploadTask uploadTask = ref.putFile(file);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      _saveFileInfoToDatabase(templateName, downloadURL);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$templateName uploaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload $templateName')),
      );
    }
  }

  Future<void> _saveFileInfoToDatabase(
      String templateName, String downloadURL) async {
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.reference().child('template-doc');
    await databaseRef.child(templateName).update({
      'name': templateName,
      'url': downloadURL,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  int _selectedIndex = 1;

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
      body: ListView.builder(
        itemCount: templates.length,
        itemBuilder: (context, index) {
          String templateName = templates[index];
          return ListTile(
            title: Text(templateName),
            trailing: IconButton(
              icon: Icon(Icons.file_upload),
              onPressed: () {
                _pickFile(templateName);
              },
            ),
          );
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
}
