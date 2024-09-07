import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'DetailAspirasiWarga.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart' as BarNavigasi;

class AspirasiWarga extends StatefulWidget {
  @override
  _AspirasiWargaState createState() => _AspirasiWargaState();
}

class _AspirasiWargaState extends State<AspirasiWarga> {
  int _selectedIndex = 0;
  final DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('aspirasi-warga');
  List<Map<dynamic, dynamic>> aspirasiList = [];

  @override
  void initState() {
    super.initState();
    _fetchAspirasi();
  }

  Future<void> _fetchAspirasi() async {
    // Mengganti `once()` dengan `get()`
    DataSnapshot snapshot = await dbRef.get();
    
    var tempList = <Map<dynamic, dynamic>>[];
    Map<dynamic, dynamic>? values = snapshot.value as Map<dynamic, dynamic>?;

    // Jika tidak null, proses data dari Firebase
    if (values != null) {
      values.forEach((key, value) {
        tempList.add(value);
      });
    }

    setState(() {
      aspirasiList = tempList;
    });
  }

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
      body: aspirasiList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: aspirasiList.length,
              itemBuilder: (context, index) {
                final aspirasi = aspirasiList[index];
                return GestureDetector(
                  onTap: () {
                    // Navigasi ke halaman detail dengan mengirim data aspirasi
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailAspirasiWarga(
                          topik: aspirasi['Topik'],
                          judul: aspirasi['Judul'],
                          detail: aspirasi['Detail'],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF7CB083),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            aspirasi['Topik'] ?? 'Topik tidak ada',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            aspirasi['Judul'] ?? 'Judul tidak ada',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "Selengkapnya",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
