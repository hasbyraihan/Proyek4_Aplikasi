import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AdminUploadTemplatePage extends StatefulWidget {
  @override
  _AdminUploadTemplatePageState createState() => _AdminUploadTemplatePageState();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Template'),
      ),
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
    );
  }
}
