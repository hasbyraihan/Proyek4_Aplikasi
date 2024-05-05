import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_helloo_world/Mahasiswa/MahasiwaDashboard.dart';
import 'package:flutter_helloo_world/Faq.dart';

import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class RatingPengabdian extends StatefulWidget {
  @override
  _RatingPengabdianState createState() => _RatingPengabdianState();
}

class _RatingPengabdianState extends State<RatingPengabdian>{
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
            color: Color.fromARGB(255, 255, 255, 255),
            text: 'Rating',
            description: 'abogoboga',
          ),
          CustomContainer(
            color: Color.fromARGB(255, 255, 255, 255),
            text: 'Evaluasi',
            description: 'bagus',
          ),
          CustomContainer(
            color: Color.fromARGB(255, 255, 255, 255),
            text: 'Saran',
            description: 'testing aja inimah',
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
  final String text;
  final String description;
  final Color color;

  const CustomContainer({
    Key? key,
    required this.text,
    required this.description,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 1, // Lebar garis vertikal
            color: Colors.black, // Warna garis vertikal
            margin: EdgeInsets.symmetric(vertical: 5), // Jarak antara garis vertikal dengan teks
          ),
          Text(
            description,
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
