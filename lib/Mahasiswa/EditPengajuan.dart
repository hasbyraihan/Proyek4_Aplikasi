import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_helloo_world/Mahasiswa/ProgresPengajuan.dart';

class EditPengajuan extends StatefulWidget {
  final String pengajuanId;

  EditPengajuan({required this.pengajuanId});

  @override
  _EditPengajuanState createState() => _EditPengajuanState();
}

class _EditPengajuanState extends State<EditPengajuan> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child("pengajuan");

  // Get the current user
  final User? user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 1;

  TextEditingController perguruanTinggiController = TextEditingController();
  TextEditingController jurusanController = TextEditingController();
  TextEditingController namaProgramController = TextEditingController();
  TextEditingController jumlahLakiLakiController = TextEditingController();
  TextEditingController jumlahPerempuanController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController dateAkhirController = TextEditingController();

  final List<String> rwOptions = [
    'RW 1',
    'RW 2',
    'RW 3',
    'RW 4',
    'RW 5',
    'RW 6',
    'RW 7',
    'RW 8',
    'RW 9',
    'RW 10'
  ];
  String? selectedRW;

  final List<String> bidangPengabdianOptions = [
    'Penelitian',
    'Pendidikan',
    'Lingkungan',
    'Pembangunan',
    'Kesehatan'
  ];
  String? selectedBidangPengabdian =
      'Penelitian'; // Set default value to avoid null

  @override
  void initState() {
    super.initState();
    _fetchPengajuanData();
  }

  Future<void> _fetchPengajuanData() async {
    try {
      DatabaseEvent event = await _database.child(widget.pengajuanId).once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);

        setState(() {
          perguruanTinggiController.text = data['perguruanTinggi'];
          jurusanController.text = data['jurusan'];
          namaProgramController.text = data['namaProgram'];
          jumlahLakiLakiController.text = data['jumlahLakiLaki'];
          jumlahPerempuanController.text = data['jumlahPerempuan'];
          dateController.text = data['tanggalAwal'];
          dateAkhirController.text = data['tanggalSelesai'];
          selectedRW = data['rw'];
          selectedBidangPengabdian = data['bidangPengabdian'];
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching data: $e'),
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        dateAkhirController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<String?> _submitForm() async {
    if (_validateFields()) {
      try {
        DatabaseReference newRef = _database.child(widget.pengajuanId);

        await newRef.update({
          'uid': user?.uid,
          'perguruanTinggi': perguruanTinggiController.text,
          'jurusan': jurusanController.text,
          'namaProgram': namaProgramController.text,
          'bidangPengabdian': selectedBidangPengabdian,
          'jumlahLakiLaki': jumlahLakiLakiController.text,
          'jumlahPerempuan': jumlahPerempuanController.text,
          'tanggalAwal': dateController.text,
          'tanggalSelesai': dateAkhirController.text,
          'rw': selectedRW,
          'statuspengajuan': "BelumDiverifikasi",
        });

        return newRef.key; // Return the generated ID
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving data: $e'),
          ),
        );
        return null;
      }
    }
    return null;
  }

  bool _validateFields() {
    if (perguruanTinggiController.text.isEmpty ||
        jurusanController.text.isEmpty ||
        namaProgramController.text.isEmpty ||
        jumlahLakiLakiController.text.isEmpty ||
        jumlahPerempuanController.text.isEmpty ||
        dateController.text.isEmpty ||
        dateAkhirController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Isi dulu yaa temen temen'),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CustomContainer(
                label: 'Perguruan Tinggi',
                icon: Icons.assured_workload,
                controller: perguruanTinggiController,
              ),
              SizedBox(height: 10),
              CustomContainer(
                label: 'Jurusan',
                icon: Icons.school_outlined,
                controller: jurusanController,
              ),
              SizedBox(height: 10),
              CustomContainer(
                label: 'Nama Program',
                icon: Icons.webhook_rounded,
                controller: namaProgramController,
              ),
              SizedBox(height: 10),
              CustomContainer(
                label: 'Bidang Pengabdian',
                icon: Icons.group_work_sharp,
                options: bidangPengabdianOptions,
                value: selectedBidangPengabdian,
                onChanged: (newValue) {
                  setState(() {
                    selectedBidangPengabdian = newValue;
                  });
                },
              ),
              SizedBox(height: 10),
              CustomContainer(
                label: 'Jumlah Peserta Laki-Laki',
                icon: Icons.person,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: jumlahLakiLakiController,
              ),
              SizedBox(height: 10),
              CustomContainer(
                label: 'Jumlah Peserta Perempuan',
                icon: Icons.person_2,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: jumlahPerempuanController,
              ),
              SizedBox(height: 10),
              CustomContainer(
                label: 'Tanggal Awal Pengabdian',
                icon: Icons.calendar_today,
                controller: dateController,
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 10),
              CustomContainer(
                label: 'Tanggal Selesai Pengabdian',
                icon: Icons.calendar_today,
                controller: dateAkhirController,
                onTap: () => _selectDate2(context),
              ),
              SizedBox(height: 10),
              CustomContainer(
                label: 'RW',
                icon: Icons.maps_home_work,
                options: rwOptions,
                value: selectedRW,
                onChanged: (newValue) {
                  setState(() {
                    selectedRW = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_validateFields()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PengajuanUploadFile(
                          perguruanTinggi: perguruanTinggiController.text,
                          jurusan: jurusanController.text,
                          namaProgram: namaProgramController.text,
                          bidangPengabdian: selectedBidangPengabdian!,
                          jumlahLakiLaki: jumlahLakiLakiController.text,
                          jumlahPerempuan: jumlahPerempuanController.text,
                          tanggalAwal: dateController.text,
                          tanggalSelesai: dateAkhirController.text,
                          rw: selectedRW,
                          pengajuanId: widget.pengajuanId,
                          submitFormCallback: _submitForm,
                        ),
                      ),
                    );
                  }
                },
                child: Text('Selanjutnya'),
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

class CustomContainer extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onTap;
  final List<String>? options;
  final String? value;
  final void Function(String?)? onChanged;

  CustomContainer({
    required this.label,
    required this.icon,
    this.controller,
    this.inputFormatters,
    this.onTap,
    this.options,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (options != null && onChanged != null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(icon),
              labelText: label,
            ),
            value: value,
            onChanged: onChanged,
            items: options!
                .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                .toList(),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            inputFormatters: inputFormatters,
            onTap: onTap,
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(icon),
              labelText: label,
            ),
          ),
        ),
      );
    }
  }
}

class PengajuanUploadFile extends StatefulWidget {
  final String perguruanTinggi;
  final String jurusan;
  final String namaProgram;
  final String bidangPengabdian;
  final String jumlahLakiLaki;
  final String jumlahPerempuan;
  final String tanggalAwal;
  final String tanggalSelesai;
  final String? rw;
  final String? pengajuanId;
  final Future<String?> Function() submitFormCallback;

  PengajuanUploadFile({
    required this.perguruanTinggi,
    required this.jurusan,
    required this.namaProgram,
    required this.bidangPengabdian,
    required this.jumlahLakiLaki,
    required this.jumlahPerempuan,
    required this.tanggalAwal,
    required this.tanggalSelesai,
    this.rw,
    this.pengajuanId,
    required this.submitFormCallback,
  });

  @override
  _PengajuanUploadFileState createState() => _PengajuanUploadFileState();
}

class _PengajuanUploadFileState extends State<PengajuanUploadFile> {
  int _selectedIndex = 1;
  Map<String, File?> templateFiles = {
    'Surat Izin Desa': null,
    'Surat Izin Kecamatan': null,
    'Surat Izin PT': null,
    'Surat Izin Koramil': null,
    'Surat Izin Kapolsek': null,
  };
  Map<String, String?> uploadedFileNames = {
    'Surat Izin Desa': null,
    'Surat Izin Kecamatan': null,
    'Surat Izin PT': null,
    'Surat Izin Koramil': null,
    'Surat Izin Kapolsek': null,
  };

  Future<void> _pickFile(String key) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          templateFiles[key] = File(result.files.single.path!);
          uploadedFileNames[key] = result.files.single.name;
        });
      }
    } catch (e) {
      print("Error picking file: $e");
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
      print("Error uploading file: $e");
    }
  }

  void _saveAllFiles() async {
    bool allFilesUploaded = templateFiles.values.every((file) => file != null);

    if (allFilesUploaded) {
      try {
        // Get the pengajuan ID by submitting the form via the callback
        String? pengajuanId = await widget.submitFormCallback();

        if (pengajuanId != null) {
          for (var entry in templateFiles.entries) {
            await _uploadFile(pengajuanId, entry.key, entry.value!);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Yeayy, data berhasil dikirim!'),
            ),
          );

          // Navigate to the dashboard page and remove all previous routes
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ProgresPengajuan()),
            (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading files: $e'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Eitss, upload dokumen nya dulu yaa'),
        ),
      );
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildUploadRow('Surat Izin Desa'),
            _buildUploadRow('Surat Izin Kecamatan'),
            _buildUploadRow('Surat Izin PT'),
            _buildUploadRow('Surat Izin Koramil'),
            _buildUploadRow('Surat Izin Kapolsek'),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: _saveAllFiles,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              ),
              child: Text('Simpan Semua File'),
            ),
          ],
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

  Widget _buildUploadRow(String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            key,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: uploadedFileNames[key] == null
                    ? ElevatedButton.icon(
                        onPressed: () => _pickFile(key),
                        icon: Icon(
                          Icons.upload_file,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Unggah File PDF',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.file_present, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              uploadedFileNames[key]!,
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
