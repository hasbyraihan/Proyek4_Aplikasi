import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:flutter_helloo_world/Mahasiswa/MahasiwaDashboard.dart';

class Pengajuan extends StatefulWidget {
  @override
  _PengajuanState createState() => _PengajuanState();
}

class _PengajuanState extends State<Pengajuan> {
  int _selectedIndex = 0;

  TextEditingController perguruanTinggiController = TextEditingController();
  TextEditingController jurusanController = TextEditingController();
  TextEditingController namaProgramController = TextEditingController();
  TextEditingController jumlahLakiLakiController = TextEditingController();
  TextEditingController jumlahPerempuanController = TextEditingController();
  TextEditingController dateController = TextEditingController();

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

  bool _validateFields() {
    if (perguruanTinggiController.text.isEmpty ||
        jurusanController.text.isEmpty ||
        namaProgramController.text.isEmpty ||
        jumlahLakiLakiController.text.isEmpty ||
        jumlahPerempuanController.text.isEmpty ||
        dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Isi dulu yaa temen temen :p'),
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
                hintText: 'Perguruan Tinggi',
                label: 'Perguruan Tinggi',
                icon: Icons.assured_workload,
                controller: perguruanTinggiController,
              ),
              SizedBox(height: 10),
              CustomContainer(
                hintText: 'Jurusan',
                label: 'Jurusan',
                icon: Icons.school_outlined,
                controller: jurusanController,
              ),
              SizedBox(height: 10),
              CustomContainer(
                hintText: 'Nama Program',
                label: 'Nama Program',
                icon: Icons.webhook_rounded,
                controller: namaProgramController,
              ),
              SizedBox(height: 10),
              CustomContainer(
                hintText: 'Bidang Pengabdian',
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
                hintText: 'Jumlah Peserta Laki-Laki',
                label: 'Jumlah Peserta Laki-Laki',
                icon: Icons.person,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: jumlahLakiLakiController,
              ),
              SizedBox(height: 10),
              CustomContainer(
                hintText: 'Jumlah Peserta Perempuan',
                label: 'Jumlah Peserta Perempuan',
                icon: Icons.person_2,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: jumlahPerempuanController,
              ),
              SizedBox(height: 10),
              CustomContainer(
                hintText: 'DD/MM/YY',
                label: 'DD/MM/YY',
                icon: Icons.calendar_today,
                controller: dateController,
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 10),
              CustomContainer(
                hintText: 'RW',
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
                          tanggal: dateController.text,
                          rw: selectedRW,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black,
                ),
                child: Text('Halaman Selanjutnya'),
              ),
              SizedBox(height: 10),
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

class PengajuanUploadFile extends StatefulWidget {
  final String perguruanTinggi;
  final String jurusan;
  final String namaProgram;
  final String bidangPengabdian;
  final String jumlahLakiLaki;
  final String jumlahPerempuan;
  final String tanggal;
  final String? rw;

  PengajuanUploadFile({
    required this.perguruanTinggi,
    required this.jurusan,
    required this.namaProgram,
    required this.bidangPengabdian,
    required this.jumlahLakiLaki,
    required this.jumlahPerempuan,
    required this.tanggal,
    this.rw,
  });

  @override
  _PengajuanUploadFileState createState() => _PengajuanUploadFileState();
}

class _PengajuanUploadFileState extends State<PengajuanUploadFile> {
  int _selectedIndex = 0;
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

  void _saveAllFiles() {
    bool allFilesUploaded = templateFiles.values.every((file) => file != null);

    if (allFilesUploaded) {
      // Simpan data dan file PDF ke database atau penyimpanan lokal di sini

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yeayy, data berhasil dikirim!'),
        ),
      );

      // Navigate to the dashboard page and remove all previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MahasiswaDashboard()),
        (Route<dynamic> route) => false,
      );
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

class CustomContainer extends StatelessWidget {
  final String hintText;
  final String label;
  final IconData icon;
  final List<String>? options;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;

  const CustomContainer({
    Key? key,
    required this.hintText,
    required this.label,
    required this.icon,
    this.options,
    this.value,
    this.onChanged,
    this.onTap,
    this.controller,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (options != null && onChanged != null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(icon),
            ),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: value,
                onChanged: onChanged,
                items: options!.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: label,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(icon),
            ),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: hintText,
                  labelText: label,
                  border: InputBorder.none,
                ),
                onTap: onTap,
                readOnly: onTap != null,
                controller: controller,
                inputFormatters: inputFormatters,
              ),
            ),
          ],
        ),
      );
    }
  }
}
