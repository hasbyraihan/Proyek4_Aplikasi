import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminDokumentasiRW.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminKebutuhan.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminPopulasi.dart';
import 'package:flutter_helloo_world/Faq.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class AdminManageInfo extends StatefulWidget {
  @override
  _AdminManageInfoState createState() => _AdminManageInfoState();
}

class _AdminManageInfoState extends State<AdminManageInfo> {
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
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: 16), // Tambahkan padding horizontal di sini
        children: [
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Populasi',
            additionalText: 'Warga Desa',
            icon: Icons.person_add_alt,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminPopulasi()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Dokumentasi',
            additionalText: 'Desa',
            icon: Icons.photo_camera_back_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FAQ()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Dokumentasi',
            additionalText: 'Per RW',
            icon: Icons.photo_camera_back_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminDokumentasiRW()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Kebutuhan',
            additionalText: 'Rukun Warga',
            icon: Icons.holiday_village_sharp,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminKebutuhan()),
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
