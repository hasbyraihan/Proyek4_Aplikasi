import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminEditFasilitasRW.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminEditLingkunganRW.dart';

import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class AdminDokumentasiRW extends StatefulWidget {
  const AdminDokumentasiRW({Key? key}) : super(key: key);

  @override
  _AdminDokumentasiRWState createState() => _AdminDokumentasiRWState();
}

class _AdminDokumentasiRWState extends State<AdminDokumentasiRW> {
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

  void _showChoiceDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pilih Salah satu",
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text("Edit Fasilitas atau Lingkungan ?"),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminEditDokumentasiRW(
                                  title: title,
                                ),
                              ),
                            );
                          },
                          child: Text("Fasilitas"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminEditLingkunganRW(
                                  title: title,
                                ),
                              ),
                            );
                          },
                          child: Text("Lingkungan"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
                _showChoiceDialog(context, items[index]['title']!);
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
