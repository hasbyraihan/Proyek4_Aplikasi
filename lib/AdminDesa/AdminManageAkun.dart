import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminAddAkun.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminKebutuhan.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminPopulasi.dart';
import 'package:flutter_helloo_world/Faq.dart';

import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class AdminManageAkun extends StatefulWidget {
  @override
  _AdminManageAkunState createState() => _AdminManageAkunState();
}

class _AdminManageAkunState extends State<AdminManageAkun> {
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
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: 16), // Tambahkan padding horizontal di sini
        children: [
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Populasi',
            additionalText: 'Warga Desa',
            icon1: Icons.edit,
            onTapIcon1: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminPopulasi()),
              );
            },
            icon2: Icons.delete,
            onTapIcon2: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FAQ()), // Ganti dengan halaman yang sesuai
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tambahkan fungsi yang diinginkan di sini
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddAkun()), // Ganti dengan halaman yang sesuai
          );
        },
        backgroundColor: Color(0xFF60AD77), // Warna hijau
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
  final IconData icon1;
  final VoidCallback onTapIcon1;
  final IconData icon2;
  final VoidCallback onTapIcon2;

  const CustomContainer({
    Key? key,
    required this.color,
    required this.text,
    required this.additionalText,
    required this.icon1,
    required this.onTapIcon1,
    required this.icon2,
    required this.onTapIcon2,
  }) : super(key: key);

  final double _width = 207; // Atur lebar container di sini
  final double _height = 130; // Atur tinggi container di sini

  @override
  Widget build(BuildContext context) {
    return Container(
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
            left: _width / 4 - 20,
            top: _height / 2 - 35,
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
            left: _width / 4 - 20,
            top: _height / 2 + 5,
            child: Text(
              additionalText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: _width +
                80, // Posisi ikon pada 1/4 bagian dari panjang container
            top: _height / 2 - 45,
            child: GestureDetector(
              onTap: onTapIcon1,
              child: Icon(
                icon1,
                size: 35,
                color: Color.fromARGB(255, 16, 80, 8),
              ),
            ),
          ),
          Positioned(
            left: _width +
                80, // Posisi ikon pada 1/4 bagian dari panjang container
            top: _height / 2 + 5,
            child: GestureDetector(
              onTap: onTapIcon2,
              child: Icon(
                icon2,
                size: 35,
                color: Color.fromARGB(255, 16, 80, 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
