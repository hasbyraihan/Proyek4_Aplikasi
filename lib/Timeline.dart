import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Faq.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:flutter_helloo_world/TimelineDetail.dart';
// Import History

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  int _selectedIndex = 1; // Deklarasi dan inisialisasi _selectedIndex

  final List<Map<String, String>> rwData = [
    {'rw': 'RW 1', 'name': 'Sinumbra'},
    {'rw': 'RW 2', 'name': 'Ciparay'},
    {'rw': 'RW 3', 'name': 'Persil'},
    {'rw': 'RW 4', 'name': 'Nyampay'},
    {'rw': 'RW 5', 'name': 'Stamplat'},
    {'rw': 'RW 6', 'name': 'Kanaan'},
    {'rw': 'RW 7', 'name': 'Lokasi 7'},
    {'rw': 'RW 8', 'name': 'Lokasi 8'},
    {'rw': 'RW 9', 'name': 'Lokasi 9'},
    {'rw': 'RW 10', 'name': 'Lokasi 10'},
  ];

  void _onItemTapped(String rw) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimelineDetail(rw: rw), // Pass RW to History
      ),
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
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
            horizontal: 16), // Tambahkan padding horizontal di sini
        itemCount: rwData.length,
        itemBuilder: (context, index) {
          return CustomContainer(
            color: Color(0xFF60AD77),
            text: rwData[index]['name']!,
            topLeftText: rwData[index]['rw']!,
            onTap: () => _onItemTapped(rwData[index]['rw']!),
          );
        },
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
  final String topLeftText;
  final VoidCallback onTap;

  const CustomContainer({
    Key? key,
    required this.color,
    required this.text,
    required this.topLeftText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth * 0.9; // 90% of screen width
    double containerHeight = containerWidth *
        0.2; // Adjust height based on width, maintaining aspect ratio

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: containerWidth,
        height: containerHeight,
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
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
