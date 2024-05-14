import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

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
  ];

  Map<String, File?> templateFiles = {};

    Future<void> _pickFile(String templateName) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        templateFiles[templateName] = file;
      });
      _uploadFileToFirebase(templateName, file);
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

  Future<void> _saveFileInfoToDatabase(String templateName, String downloadURL) async {
    DatabaseReference databaseRef = FirebaseDatabase.instance.reference().child('template-doc');
    await databaseRef.child(templateName).update({
      'name': templateName,
      'url': downloadURL,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  int _selectedIndex = 0;
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
