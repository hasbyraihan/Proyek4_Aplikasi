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
  TextEditingController dateController = TextEditingController();

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
        dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Map<String, File?> templateFiles = {};

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          templateFiles['templateName'] = File(result.files.single.path!);
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
              ),
              SizedBox(height: 10),
              CustomContainer(
                hintText: 'Nama Program',
                label: 'Nama Program',
                icon: Icons.assured_workload,
              ),
              SizedBox(height: 10),
              CustomContainer(
                hintText: 'Bidang Pengabdian',
                label: 'Bidang Pengabdian',
                icon: Icons.assured_workload,
              ),
              SizedBox(height: 10),
              CustomContainer(
                hintText: 'Jumlah Peserta',
                label: 'Jumlah Peserta',
                icon: Icons.assured_workload,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              SizedBox(height: 10),
              CustomContainer(
                hintText: 'DD/MM/YY',
                label: 'DD/MM/YY',
                icon: Icons.assured_workload,
                controller: dateController,
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 10),
              CustomContainer(
                hintText: 'RW',
                label: 'RW',
                icon: Icons.assured_workload,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Dokumen Pendukung',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: Icon(Icons.upload_file),
                label: Text('Unggah File PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Atur warna tombol
                ),
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

class CustomContainer extends StatelessWidget {
  final String hintText;
  final String label;
  final IconData icon;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final VoidCallback? onTap;

  const CustomContainer({
    Key? key,
    required this.hintText,
    required this.label,
    required this.icon,
    this.inputFormatters,
    this.keyboardType,
    this.controller,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                labelText: label,
                border: InputBorder.none,
              ),
              inputFormatters: inputFormatters,
              keyboardType: keyboardType,
              onTap: onTap,
              readOnly: onTap != null, // Set TextField to readOnly if onTap is provided
            ),
          ),
        ],
      ),
    );
  }
}
