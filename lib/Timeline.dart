import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Dashboard.dart';
import 'package:flutter_helloo_world/Auth/login.dart';
import 'package:flutter_helloo_world/Faq.dart';
import 'package:flutter_helloo_world/History.dart';
import 'package:flutter_helloo_world/timelineDetail.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
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
        padding: EdgeInsets.symmetric(
            horizontal: 16), // Tambahkan padding horizontal di sini
        children: [
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Sinumbra',
            topLeftText: 'RW 1',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimelineDetail()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Ciparay',
            topLeftText: 'RW 2',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimelineDetail()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Persil',
            topLeftText: 'RW 3',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimelineDetail()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Nyampay',
            topLeftText: 'RW 4',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimelineDetail()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Stamplat',
            topLeftText: 'RW 5',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimelineDetail()),
              );
            },
          ),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'Kanaan',
            topLeftText: 'RW 6',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimelineDetail()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.black, // Ubah warna background menjadi hitam
        selectedItemColor:
            Colors.black, // Ubah warna ikon yang dipilih menjadi putih
        unselectedItemColor:
            Colors.grey, // Ubah warna ikon yang tidak dipilih menjadi abu-abu
        onTap: (index) {
          // Fungsi untuk menangani navigasi berdasarkan index yang dipilih
          setState(() {
            _selectedIndex = index;
            // Navigasi ke halaman yang sesuai berdasarkan index
            if (_selectedIndex == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            } else {
              // Implementasi navigasi ke halaman lain jika diperlukan
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                // Fungsi untuk menangani ketika item "Calendar" ditekan
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.calendar_today), // Ganti ikon dengan kalender
              onPressed: () {
                // Fungsi untuk menangani ketika item "Calendar" ditekan
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Timeline()),
                );
              },
            ),
            label: 'Timeline', // Atur label sesuai dengan kebutuhan
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.history), // Ganti ikon dengan ikon untuk history
              onPressed: () {
                // Fungsi untuk menangani ketika item "History" ditekan
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => History()),
                );
              },
            ),
            label: 'History', // Ubah label menjadi "History"
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                // Fungsi untuk menangani ketika item "Profile" ditekan
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final Color color;
  final String text;
  final String topLeftText;
  final VoidCallback onTap;

  const CustomContainer({
    Key? key,
    required this.color,
    required this.text,
    required this.topLeftText,
    required this.onTap,
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
              left: 8, // Padding dari sisi kiri
              top: 8, // Padding dari atas
              child: Text(
                topLeftText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
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
