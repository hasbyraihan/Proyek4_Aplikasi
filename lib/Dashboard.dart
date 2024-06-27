import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_helloo_world/Faq.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MyDashboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simpemas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

Future<List<RWData>> fetchRWDataFromFirebase() async {
  try {
    final userRef = FirebaseDatabase.instance.ref('info-desa/kebutuhan-rw');
    final userSnapshot = await userRef.get();

    List<RWData> rwDataList = [];
    if (userSnapshot.value != null) {
      Map<dynamic, dynamic> data = userSnapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        final rwNumber = value['rw'] as int;
        final needs = List<String>.from(value['kebutuhan'] ?? []);
        rwDataList.add(RWData(rwNumber: rwNumber, needs: needs));
      });
      return rwDataList;
    } else {
      throw 'Data not found';
    }
  } catch (e) {
    throw 'Error: $e';
  }
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  int pria = 0;
  int wanita = 0;
  String total = '';
  late Future<List<RWData>> rwDataFuture = fetchRWDataFromFirebase();

  Future<void> fetchPopulasi() async {
    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('info-desa/populasi').get();

      if (snapshot.exists) {
        Map<Object?, Object?>? data = snapshot.value as Map<Object?, Object?>?;
        if (data != null) {
          setState(() {
            pria = data['pria'] as int;
            wanita = data['wanita'] as int;
            total = data['total'] as String? ?? 'Data not available';
          });
        } else {
          setState(() {
            pria = 100;
            wanita = 10;
          });
        }
      } else {
        setState(() {
          total = 'Failed to fetch data: Data not found';
          print('Failed to fetch data: Data not found');
        });
      }
    } catch (e) {
      setState(() {
        total = 'Error: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPopulasi();
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 10),
              ContainerCard(
                // title: 'Lokasi Indragiri',
                // imagePath: 'assets/images/peta.png',
                lat: -7.130000,
                leng: 107.340000,
                zoom: 13.0,
              ),
              SizedBox(height: 10),
              ContainerCardPopulation(
                title: 'Populasi Warga',
                malePopulation: pria,
                femalePopulation: wanita,
              ),
              SizedBox(height: 10),
              ContainerCardCarousel(
                title: 'Dokumentasi Desa',
                imagePaths: [
                  'assets/images/dokumentasi.png',
                  'assets/images/dokumentasi.png',
                  'assets/images/dokumentasi.png',
                ],
              ),
              SizedBox(height: 10),
              FutureBuilder<List<RWData>>(
                future: rwDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Menampilkan loading indicator saat data sedang diambil
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error: ${snapshot.error}'); // Menampilkan pesan error jika terjadi kesalahan
                  } else {
                    return ContainerCardRW(
                        rwDataList: snapshot.data ??
                            []); // Menampilkan ContainerCardRW dengan data RW yang telah diambil
                  }
                },
              ),
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

class ContainerCard extends StatelessWidget {
  // final String title;
  // final String? imagePath;
  final double lat;
  final double leng;
  final double zoom;

  const ContainerCard(
      {Key? key, required this.lat, required this.leng, required this.zoom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 237,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(lat, leng),
          initialZoom: zoom,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
        ],
      ),
    );
  }
}

class ContainerCardCarousel extends StatelessWidget {
  final String title;
  final List<String> imagePaths;

  const ContainerCardCarousel({
    Key? key,
    required this.title,
    required this.imagePaths,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 237,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: CarouselSlider(
              items: imagePaths.map((path) {
                return Container(
                  width: double.infinity,
                  child: Image.asset(
                    path,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 180.0,
                viewportFraction: 0.8,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContainerCardPopulation extends StatelessWidget {
  final String title;
  final int malePopulation;
  final int femalePopulation;

  const ContainerCardPopulation({
    Key? key,
    required this.title,
    required this.malePopulation,
    required this.femalePopulation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalPopulation = malePopulation + femalePopulation;

    return Container(
      width: 380,
      height: 237,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Column(
              children: [
                _buildPopulationBox(
                    'Total', totalPopulation, Color(0xFF60AD77)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPopulationBox(
                        'Laki-laki', malePopulation, Color(0xFF60AD77)),
                    _buildPopulationBox(
                        'Perempuan', femalePopulation, Color(0xFF60AD77)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopulationBox(String label, int population, Color color) {
    return Container(
      width: 150,
      height: 50, // Sesuaikan tinggi dengan kebutuhan Anda
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1),
          Text(
            population.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ContainerCardRW extends StatelessWidget {
  final List<RWData> rwDataList;

  const ContainerCardRW({
    Key? key,
    required this.rwDataList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 237,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Kebutuhan per RW',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: rwDataList.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 200,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildRWCard(rwDataList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRWCard(RWData rwData) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(8.0),
      width: 354,
      height: 132, // Ukuran yang diminta
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RW ${rwData.rwNumber}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Kebutuhan',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            height: 72, // Tinggi container untuk daftar kebutuhan
            child: ListView(
              children: rwData.needs.map((need) {
                return Text(
                  '- ${need}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class RWData {
  final int rwNumber;
  final List<String> needs;

  RWData({
    required this.rwNumber,
    required this.needs,
  });
}
