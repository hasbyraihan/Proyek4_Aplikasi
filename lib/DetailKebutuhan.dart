import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Faq.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:carousel_slider/carousel_slider.dart';

class DetailDokumentasiRW extends StatefulWidget {
  const DetailDokumentasiRW({Key? key}) : super(key: key);

  @override
  _DetailDokumentasiRWState createState() => _DetailDokumentasiRWState();
}

class _DetailDokumentasiRWState extends State<DetailDokumentasiRW> {
  int _selectedIndex = 0;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              KebutuhanCard(
                title: 'Kebutuhan RW 1',
                needs: [
                  'Kurangnya minat kuliah bagi anak sma',
                  'Banyak balita sakit kekurangan gizi',
                  'Warga yang belum terbiasa dengan iptek',
                ],
              ),
              ContainerCardCarousel(
                title: 'Fasilitas RW',
                imagePaths: [
                  'assets/images/dokumentasi.png',
                  'assets/images/dokumentasi.png',
                  'assets/images/dokumentasi.png',
                ],
              ),
              ContainerCardCarousel(
                title: 'Lingkungan RW',
                imagePaths: [
                  'assets/images/dokumentasi.png',
                  'assets/images/dokumentasi.png',
                  'assets/images/dokumentasi.png',
                ],
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
  final List<String> imagePaths;

  const ContainerCardCarousel({
    Key? key,
    required this.title,
    required this.imagePaths,
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
}