import 'package:flutter/material.dart';

import 'package:flutter_helloo_world/Faq.dart';

import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;


class TimeSinum extends StatefulWidget {
  @override
  _TimeSinumState createState() => _TimeSinumState();
}

class _TimeSinumState extends State<TimeSinum> {
  int _selectedIndex = 1; // Deklarasi dan inisialisasi _selectedIndex
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
        padding: EdgeInsets.symmetric(horizontal: 16), // Tambahkan padding horizontal di sini
        children: [
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'ANANTARA',
            topLeftText: 'Politeknik Negeri Bandung',
            additionalText: 'Sinumbra',
            TanggalText: '21 Maret - 24 Maret',
            TahunText: '2023',
            logoPath: 'assets/images/logopolban.png', // Memberikan path gambar logo
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Sewatana',
            topLeftText: 'Universitas Gajah Mada',
            additionalText: 'Ciparay',
            TanggalText: '2 Juli - 24 April',
            TahunText: '2023',
            logoPath: 'assets/images/logougm.png', // Memberikan path gambar logo
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Gerakan Unpad Mengajar ',
            topLeftText: 'Universitas Padjajaran',
            additionalText: 'Eul - Eul',
            TanggalText: '2 Januari - 24 April',
            TahunText: '2023',
            logoPath: 'assets/images/logounpad.png', // Memberikan path gambar logo
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
      ), );
  }
}

class CustomContainer extends StatelessWidget {
  final Color color;
  final String text;
  final String topLeftText;
  final String additionalText;
  final String TanggalText;
  final String TahunText;
  final String logoPath; // Menambahkan path gambar logo

  const CustomContainer({
    Key? key,
    required this.color,
    required this.text,
    required this.topLeftText,
    required this.additionalText,
    required this.TanggalText,
    required this.TahunText,
    required this.logoPath, // Menambahkan path gambar logo
  }) : super(key: key);

  final double _width = 200; // Atur lebar container di sini
  final double _height = 140; // Atur tinggi container di sini

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
            left: 17, // Padding dari sisi kiri
            top: 36, // Padding dari atas
            
            child: Image.asset( // Menambahkan gambar logo
              logoPath,
              width: 70, // Ukuran gambar logo
              height: 70,
            ),
          ),
          Positioned(
            left: (_width) / 2, // Menempatkan teks di tengah horizontal berdasarkan lebar container dan lebar gambar logo
            top: 12, // Padding dari atas
            child: Align(
              alignment: Alignment.center, // Menyatukan teks ke tengah horizontal dari container
              child: Text(
                topLeftText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            left: (_width) / 2, // Menempatkan teks di tengah horizontal berdasarkan lebar container dan lebar gambar logo
            top: 12 + 20 + 8, // Padding dari atas + tinggi teks topLeftText + padding tambahan
            child: Align(
              alignment: Alignment.center, // Menyatukan teks ke tengah horizontal dari container
              child: Text(
                '"' + text + '"' ,
                style: TextStyle(
                  color: Color.fromARGB(255, 89, 255, 0),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            left: (_width) /2,
            top: 12 + 20 + 8 + 20 + 8 + 18 + 8,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Lokasi : ' + additionalText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            left: (_width) /2,
            top: 12 + 20 + 8 + 20 + 8,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Tanggal : ' + TanggalText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            left: (_width) + 45 ,
            top: 12 + 20 + 8 + 20 + 8 + 18 + 8,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Tahun : ' + TahunText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



