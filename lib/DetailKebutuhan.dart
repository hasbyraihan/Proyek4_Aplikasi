import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:carousel_slider/carousel_slider.dart';

class DetailDokumentasiRW extends StatefulWidget {
  final String title;

  const DetailDokumentasiRW({Key? key, required this.title}) : super(key: key);

  @override
  _DetailDokumentasiRWState createState() => _DetailDokumentasiRWState();
}

class _DetailDokumentasiRWState extends State<DetailDokumentasiRW> {
  int _selectedIndex = 0;
  RWData? rwData;
  List<String> _imagesFasilitas = [];
  List<String> _imagesLingkungan = [];

  @override
  void initState() {
    super.initState();
    _fetchRWData();
    _fetchImagesFasilitas();
    _fetchImagesLingkungan();
  }

  Future<void> _fetchRWData() async {
    try {
      final data = await fetchSingleRWDataFromFirebase(widget.title);
      setState(() {
        rwData = data;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<RWData> fetchSingleRWDataFromFirebase(String title) async {
    try {
      final rwRef =
          FirebaseDatabase.instance.ref('info-desa/kebutuhan-rw/$title');
      final rwSnapshot = await rwRef.get();

      if (rwSnapshot.value != null) {
        Map<dynamic, dynamic> data = rwSnapshot.value as Map<dynamic, dynamic>;
        final rwNumber = data['rw'];
        if (rwNumber is int) {
          // Validate rwNumber is int
          final needs = List<String>.from(data['kebutuhan'] ?? []);
          return RWData(rwNumber: rwNumber, needs: needs);
        } else {
          throw 'RW number is not an integer';
        }
      } else {
        throw 'Data not found';
      }
    } catch (e) {
      throw 'Error: $e';
    }
  }

  Future<void> _fetchImagesFasilitas() async {
    final databaseReference = FirebaseDatabase.instance
        .ref()
        .child('info-desa/kebutuhan-rw/${widget.title}/dokumentasi/fasilitas');

    final snapshot = await databaseReference.get();

    final List<String> fetchedImages = [];
    if (snapshot.exists) {
      Map<dynamic, dynamic> imagesMap = snapshot.value as Map<dynamic, dynamic>;
      imagesMap.forEach((key, value) {
        fetchedImages.add(value['imageUrl']);
      });
    }

    setState(() {
      _imagesFasilitas = fetchedImages;
    });
  }

  Future<void> _fetchImagesLingkungan() async {
    final databaseReference = FirebaseDatabase.instance
        .ref()
        .child('info-desa/kebutuhan-rw/${widget.title}/dokumentasi/lingkungan');

    final snapshot = await databaseReference.get();

    final List<String> fetchedImages = [];
    if (snapshot.exists) {
      Map<dynamic, dynamic> imagesMap = snapshot.value as Map<dynamic, dynamic>;
      imagesMap.forEach((key, value) {
        fetchedImages.add(value['imageUrl']);
      });
    }

    setState(() {
      _imagesLingkungan = fetchedImages;
    });
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (rwData != null)
                KebutuhanCard(
                  title: 'Kebutuhan RW ${rwData!.rwNumber}',
                  needs: rwData!.needs,
                ),
              ContainerCardCarousel(
                title: 'Fasilitas RW',
                imageUrls: _imagesFasilitas,
              ),
              ContainerCardCarousel(
                title: 'Lingkungan RW',
                imageUrls: _imagesLingkungan,
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

class KebutuhanCard extends StatelessWidget {
  final String title;
  final List<String> needs;

  KebutuhanCard({required this.title, required this.needs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Divider(
            color: Colors.black54,
            thickness: 1,
          ),
          SizedBox(height: 10),
          ...needs
              .map((need) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      '• $need',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}

class ContainerCardCarousel extends StatelessWidget {
  final String title;
  final List<String> imageUrls;

  const ContainerCardCarousel({
    Key? key,
    required this.title,
    required this.imageUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.9,
      height: 237,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Divider(
            color: Colors.black54,
            thickness: 1,
          ),
          Expanded(
            child: CarouselSlider(
              items: imageUrls.map((url) {
                return GestureDetector(
                  onTap: () => _showImageDialog(context, url),
                  child: Container(
                    width: double.infinity,
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 180.0,
                viewportFraction: 0.8,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class RWData {
  final int rwNumber;
  final List<String> needs;

  RWData({required this.rwNumber, required this.needs});
}
