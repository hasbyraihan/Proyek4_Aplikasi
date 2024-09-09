import 'package:flutter/material.dart';
// Adjust the path as necessary
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:flutter_helloo_world/DetailKebutuhan.dart';

class DokumentasiRW extends StatefulWidget {
  const DokumentasiRW({Key? key}) : super(key: key);

  @override
  _DokumentasiRWState createState() => _DokumentasiRWState();
}

class _DokumentasiRWState extends State<DokumentasiRW> {
  int _selectedIndex = 0;

  final List<Map<String, String>> items = [
    {"title": "rw-1", "subtitle": "Indragiri"},
    {"title": "rw-2", "subtitle": "Girimukti"},
    {"title": "rw-3", "subtitle": "Eul-eul"},
    {"title": "rw-4", "subtitle": "Sinumbra"},
    {"title": "rw-5", "subtitle": "Sinumbra"},
    {"title": "rw-6", "subtitle": "Kanaan"},
    {"title": "rw-7", "subtitle": "Ciparay"},
    {"title": "rw-8", "subtitle": "Bumi Nagara"},
    {"title": "rw-9", "subtitle": "Persil"},
    {"title": "rw-10", "subtitle": "Palawija"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC5E0CD),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Image.asset(
              'assets/images/logo.png',
              width: 54,
              height: 52,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFE9F0EB),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3 / 2,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailDokumentasiRW(
                      title: items[index]['title']!,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF60AD77),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      items[index]['title']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      items[index]['subtitle']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
