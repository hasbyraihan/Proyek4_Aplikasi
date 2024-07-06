import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:flutter_helloo_world/Mahasiswa/MahasiwaDashboard.dart';

class HasilPengabdian extends StatefulWidget {
  final String pengajuanId;

  HasilPengabdian({required this.pengajuanId});

  @override
  _HasilPengabdianState createState() => _HasilPengabdianState();
}

class _HasilPengabdianState extends State<HasilPengabdian> {
  int _selectedIndex = 0;

  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child("pengajuan");

  TextEditingController deskripsiHasilController = TextEditingController();
  File? _selectedFile;
  String? _selectedFileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _selectedFileName = result.files.single.name;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No file selected or the selected file is not a PDF'),
        ),
      );
    }
  }

  Future<void> _uploadFile(String pengajuanId, String key, File file) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('dokumen-pendukung/$pengajuanId/$key.pdf');

      await storageRef.putFile(file);

      String downloadURL = await storageRef.getDownloadURL();

      await FirebaseDatabase.instance
          .ref()
          .child('dokumen-pendukung')
          .child(pengajuanId)
          .child(key)
          .set(downloadURL);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading file: $e'),
        ),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_validateFields()) {
      try {
        await _database.child(widget.pengajuanId).update({
          'deskripsiHasil': deskripsiHasilController.text,
          'statuspengajuan': "Selesai",
        });

        if (_selectedFile != null) {
          await _uploadFile(
              widget.pengajuanId, 'Dokumen Hasil Pengabdian', _selectedFile!);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('data berhasil diupload!'),
          ),
        );

        // Navigate to the dashboard page and remove all previous routes
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MahasiswaDashboard()),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving data: $e'),
          ),
        );
      }
    }
  }

  bool _validateFields() {
    if (deskripsiHasilController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Field Wajib diisi'),
        ),
      );
      return false;
    }
    return true;
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                child: IntrinsicHeight(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Opacity(
                                opacity: 0.5,
                                child: Icon(
                                  Icons.description,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: deskripsiHasilController,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  hintText: 'Deskripsi Hasil Pengabdian...',
                                  border: InputBorder.none,
                                ),
                                maxLines: null,
                                minLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, top: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Dokumentasi',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF60AD77),
                  ),
                  onPressed: _pickFile,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.upload,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Upload PDF',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_selectedFileName != null)
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: Text(
                    'Selected file: $_selectedFileName',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF60AD77),
                  ),
                  onPressed: () async {
                    await _submitForm();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Kirim Hasil Pengabdian',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
