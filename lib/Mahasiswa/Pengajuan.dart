import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class Pengajuan extends StatefulWidget {
  @override
  _PengajuanState createState() => _PengajuanState();
}

class _PengajuanState extends State<Pengajuan> {
  int _selectedIndex = 0;

  // Controller untuk menampung nilai dari TextField
  TextEditingController perguruanTinggiController = TextEditingController();
  TextEditingController namaProgramController = TextEditingController();
  TextEditingController bidangPengabdianController = TextEditingController();
  TextEditingController jumlahLakiLakiController = TextEditingController();
  TextEditingController jumlahPerempuanController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController rwController = TextEditingController();

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
  ]; // Daftar opsi RW
  String? selectedRW; // Nilai RW yang dipilih

  final List<String> bidangOptions = [
    'Lingkungan',
    'Penelitian',
    'Pendidikan',
    'Kesehatan',
    'Pembangunan'
  ];
  String? selectedBidang;

  // Fungsi untuk menampilkan DatePicker
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

  // Fungsi untuk melakukan validasi
  bool _validateFields() {
    if (perguruanTinggiController.text.isEmpty ||
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
                label: 'Perguruan Tinggi',
                icon: Icons.assured_workload,
                controller: perguruanTinggiController,
              ),
              SizedBox(height: 10),
              CustomContainer(
                label: 'Nama Program',
                icon: Icons.assured_workload,
                controller: namaProgramController,
              ),
              SizedBox(height: 10),
              CustomContainer(
                label: 'Bidang Pengabdian',
                icon: Icons.assured_workload,
                options: bidangOptions, // Berikan daftar opsi untuk dropdown RW
                value: selectedBidang, // Nilai yang dipilih pada dropdown
                onChanged: (newValue) {
                  setState(() {
                    selectedBidang = newValue;
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
                icon: Icons.person,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: jumlahPerempuanController,
              ),
              SizedBox(height: 10),
              CustomContainer(
                label: 'DD/MM/YY',
                icon: Icons.calendar_today,
                controller: dateController,
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 10),
              CustomContainer(
                label: 'RW',
                icon: Icons.assured_workload,
                options: rwOptions, // Berikan daftar opsi untuk dropdown RW
                value: selectedRW, // Nilai yang dipilih pada dropdown
                onChanged: (newValue) {
                  setState(() {
                    selectedRW = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Lakukan validasi sebelum pindah ke halaman berikutnya
                  if (_validateFields()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PengajuanUploadFile()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Atur warna tombol
                  foregroundColor: Colors.black, // Atur warna teks
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
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          _buildUploadRow('Surat Izin Desa'),
          _buildUploadRow('Surat Izin Kecamatan'),
          _buildUploadRow('Surat Izin PT'),
          _buildUploadRow('Surat Izin Koramil'),
          _buildUploadRow('Surat Izin Kapolsek'),
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

  Widget _buildUploadRow(String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            key, // Menampilkan nama kolom
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(height: 5), // Jarak antara teks dan container
        Container(
          margin:
              EdgeInsets.symmetric(horizontal: 30), // Mengatur jarak kiri kanan
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
                          padding: EdgeInsets.symmetric(
                              vertical: 16), // Ukuran tombol vertikal
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
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final List<String>? options; // Daftar opsi dropdown
  final String? value; // Nilai yang dipilih pada dropdown
  final ValueChanged<String?>?
      onChanged; // Fungsi yang dipanggil saat nilai dropdown berubah
  final VoidCallback? onTap;

  const CustomContainer({
    Key? key,
    required this.label,
    required this.icon,
    this.inputFormatters,
    this.keyboardType,
    this.controller,
    this.options, // Tambahkan parameter untuk daftar opsi dropdown
    this.value, // Tambahkan parameter untuk nilai dropdown yang dipilih
    this.onChanged, // Tambahkan parameter untuk fungsi onChanged
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Jika widget ini adalah dropdown
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
                value: value ??
                    options!.first, // Set nilai default jika value null
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
      // Jika widget ini bukan dropdown
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
                controller:
                    controller, // Gunakan controller hanya pada TextFormField
                decoration: InputDecoration(
                  labelText: label,
                  border: InputBorder.none,
                ),
                inputFormatters: inputFormatters,
                keyboardType: keyboardType,
                onTap: onTap,
                readOnly: onTap !=
                    null, // Set TextField to readOnly if onTap is provided
              ),
            ),
          ],
        ),
      );
    }
  }
}
