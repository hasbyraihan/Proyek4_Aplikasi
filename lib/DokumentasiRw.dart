import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/DetailKebutuhan.dart';
import 'package:flutter_helloo_world/Faq.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class DokumentasiRW extends StatefulWidget {
  const DokumentasiRW({Key? key}) : super(key: key);

  @override
  _DokumentasiRWState createState() => _DokumentasiRWState();
}

class _DokumentasiRWState extends State<DokumentasiRW> {
  int _selectedIndex = 0;

  final List<Map<String, String>> items = [
    {"title": "rw-1", "subtitle": "Sinumbra"},
    {"title": "rw-2", "subtitle": "Sinumbra"},
    {"title": "rw-3", "subtitle": "Sinumbra"},
    {"title": "rw-4", "subtitle": "Sinumbra"},    
    {"title": "rw-5", "subtitle": "Sinumbra"},
    {"title": "rw-6", "subtitle": "Sinumbra"},
    {"title": "rw-7", "subtitle": "Sinumbra"},
    {"title": "rw-8", "subtitle": "Sinumbra"},
    {"title": "rw-9", "subtitle": "Sinumbra"},
    {"title": "rw-10", "subtitle": "Sinumbra"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC5E0CD),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.question_answer_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FAQ()),
            );
          },
        ),
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
                    builder: (context) => DetailDokumentasiRW(),
                  ),
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => DetailPage(
                //       title: items[index]['title']!,
                //       subtitle: items[index]['subtitle']!,
                //     ),
                //   ),
                // );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
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
