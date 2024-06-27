import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class HasilPengabdian extends StatefulWidget {
  @override
  _HasilPengabdianState createState() => _HasilPengabdianState();
}

class _HasilPengabdianState extends State<HasilPengabdian> {
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                child: IntrinsicHeight(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Opacity(
                                opacity: 0.5,
                                child: Icon(
                                  Icons.description,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  hintText: 'Deskripsi Hasil Pengabdian',
                                  border: InputBorder.none,
                                ),
                                maxLines: null,
                                minLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 30, top: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Dokumentasi',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF60AD77),
                  ),
                  onPressed: () {},
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.upload,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Upload Gambar',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF60AD77),
                  ),
                  onPressed: () {},
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Kirim Hasil Pengabdian',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
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
