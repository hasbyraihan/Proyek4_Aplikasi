import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_helloo_world/Auth/login.dart';
import 'package:flutter_helloo_world/Mahasiswa/MahasiwaDashboard.dart';
import 'package:flutter_helloo_world/Faq.dart';

import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class TemplatePengajuan extends StatefulWidget {
  @override
  _TemplatePengajuanState createState() => _TemplatePengajuanState();
}

class _TemplatePengajuanState extends State<TemplatePengajuan> {
  int _selectedIndex = 0;
  void navigateToDashboard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MahasiswaDashboard()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC5E0CD),
        automaticallyImplyLeading: false,
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.question_answer_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQ()),
                ); // Fungsi untuk menu FAQ
              },
            ),
          ],
        ),
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
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: 16), // Tambahkan padding horizontal di sini
        children: [
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Surat Izin Kapolsek',
            icon: Icons.file_download,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Surat Izin Koramil',
            icon: Icons.file_download,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Surat Izin PT',
            icon: Icons.file_download,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Surat Izin Kecamatan',
            icon: Icons.file_download,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Surat Izin Desa',
            icon: Icons.file_download,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
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
}

class CustomContainer extends StatelessWidget {
  final Color color;
  final String text;
  final VoidCallback onTap;
  final IconData icon;

  const CustomContainer({
    Key? key,
    required this.color,
    required this.text,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final double _width = 207; // Atur lebar container di sini
  final double _height = 100; // Atur tinggi container di sini

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              left: _width + 60, // 
              top: _height / 2 - 30, // Posisi ikon di tengah secara vertikal
              child: Icon(
                icon,
                size: 60, // Atur ukuran ikon sesuai kebutuhan
                color: Color.fromARGB(255, 16, 80, 8), // Atur warna ikon sesuai kebutuhan
              ),
            ),
            Positioned(
              left: _width / 4 - 20,
              top: _height / 2 - 10,
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
