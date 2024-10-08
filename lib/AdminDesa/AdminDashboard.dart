import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminContactPerson.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminDaftarRating.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminAspirasiWarga.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminFAQEditPage.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminManageAkun.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminManageInfo.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminPengajuan.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminUploadTemplatePage.dart';
import 'dart:async';

import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:flutter_helloo_world/Faq.dart';
import 'package:flutter_helloo_world/Loading.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 1;
  bool _isLoading = false; // Variabel loading

  void _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC5E0CD),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.question_answer_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FAQ()),
            ); // Fungsi untuk menu FAQ
          },
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
          // CustomContainer(
          //   color: Color(0xFF60AD77),
          //   text: 'Informasi',
          //   additionalText: 'Desa',
          //   icon: Icons.other_houses,
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => Dashboard()),
          //     );
          //   },
          // ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Manage Akun',
            additionalText: 'Desa',
            icon: Icons.person,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminManageAkun()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Manage ',
            additionalText: 'Informasi Desa',
            icon: Icons.developer_board,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminManageInfo()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Verifikasi',
            additionalText: 'Pengajuan',
            icon: Icons.bar_chart,
            onTap: () {
              _showLoading();
              Timer(Duration(seconds: 1), () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminPengajuan()));
              });
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Rating Hasil',
            additionalText: 'Pengabdian',
            icon: Icons.star_border,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminDaftarRating()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Edit Aspirasi',
            additionalText: 'Warga',
            icon: Icons.people_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminAspirasiWarga()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Edit Template',
            additionalText: 'Laporan',
            icon: Icons.upload_file,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminUploadTemplatePage()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Edit',
            additionalText: 'FAQ',
            icon: Icons.question_answer_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminFaqEditPage()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Edit Contact',
            additionalText: 'Person',
            icon: Icons.contacts,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminContactPerson(
                    contactNumber: '',
                    contactName: '',
                    contactUrl:
                        'wa.me/+62...', //nanti contact url pada nomornya diambil dari contaactnumber aja biar gausah ngisi
                  ),
                ),
              );
            },
          ),
          LoadingScreen(isLoading: _isLoading),
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
  final String additionalText;
  final VoidCallback onTap;
  final IconData icon;

  const CustomContainer({
    Key? key,
    required this.color,
    required this.text,
    required this.additionalText,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final double _width = 207; // Atur lebar container di sini
  final double _height = 130; // Atur tinggi container di sini

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
              left: _width / 4 -
                  20, // Posisi ikon pada 1/4 bagian dari panjang container
              top: _height / 2 - 40, // Posisi ikon di tengah secara vertikal
              child: Icon(
                icon,
                size: 80, // Atur ukuran ikon sesuai kebutuhan
                color: Color.fromARGB(
                    255, 16, 80, 8), // Atur warna ikon sesuai kebutuhan
              ),
            ),
            Positioned(
              left: _width * 3 / 4,
              top: _height / 2 - 25,
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              left: _width * 3 / 4,
              top: _height / 2 - 5,
              child: Text(
                additionalText,
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
