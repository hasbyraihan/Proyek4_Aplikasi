import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_helloo_world/Auth/login.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:flutter_helloo_world/Faq.dart';
import 'package:flutter_helloo_world/History.dart';
import 'package:flutter_helloo_world/Timeline.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_helloo_world/Models/User.dart' as user;
import 'package:flutter_helloo_world/Models/UserDesa.dart' as userDesa;

class DashboardNanudz extends StatefulWidget {
  @override
  _DashboardNanudzState createState() => _DashboardNanudzState();
}

class _DashboardNanudzState extends State<DashboardNanudz> {
  dynamic _user;
  int _selectedIndex = 0;
  int pria = 0;
  int wanita = 0;
  int total = 0;

  Future<void> _loadUserData() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        final userId = firebaseUser.uid;
        final userRef = FirebaseDatabase.instance.ref('/Users/$userId');
        final userSnapshot = await userRef.get();
        final userData = userSnapshot.value as Map<Object?, Object?>?;

        if (userData != null) {
          final userRole = userData['role']?.toString();

          if (userRole == 'mahasiswa') {
            setState(() {
              _user = user.User.fromMap(userData);
            });
          } else if (userRole == 'admin') {
            setState(() {
              _user = userDesa.UserDesa.fromMap(userData, userId);
            });
          } else {
            print('Error: User role is invalid or not supported');
          }
        } else {
          print('Error: User data is null');
        }
      } else {
        print('Error: No user currently logged in');
      }
    } catch (e) {
      print('Error: Failed to load user data: $e');
    }
  }

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
            total = pria + wanita;
          });
        } else {
          setState(() {
            pria = 100;
            wanita = 10;
            total = 110;
          });
        }
      } else {
        setState(() {
          print('Failed to fetch data: Data not found');
        });
      }
    } catch (e) {
      setState(() {
        print('Error: $e');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPopulasi();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.all(16),
              width: screenWidth * 0.9,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFC5E0CD),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  if (_user != null) ...[
                    if (_user.role == 'admin') ...[
                      const SizedBox(height: 30),
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(_user.fotoProfil),
                      ),
                      const SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25),
                          Text(
                            '${_user.nama}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_user.role}',
                            style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.7)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_user.jabatan}',
                            style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ] else if (_user.role == 'mahasiswa') ...[
                      const SizedBox(width: 30),
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(_user.fotoProfil),
                      ),
                      const SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25),
                          Text(
                            '${_user.nama}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_user.role}',
                            style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.7)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_user.namaPerguruanTinggi}', 
                            style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ]
                  ] else ...[
                    const SizedBox(width: 30),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(Icons.person, size: 24),
                    ),
                    const SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 25),
                        const Text(
                          'Tamu (Guest)',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF60AD77),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                color: const Color(0xFFC5E0CD),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Informasi Desa',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: 165,
                          decoration: BoxDecoration(
                            color: const Color(0xFF60AD77),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 5),
                              const Icon(Icons.people_alt_sharp,
                                  size: 20,
                                  color: Color.fromARGB(255, 49, 49, 49)),
                              const SizedBox(width: 8),
                              Text(
                                'Populasi $total',
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFFFFF)),
                              ),
                            ],
                          ),
                        ),
                      ]),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InfoCard(
                        title: 'Laki - Laki',
                        value: pria.toString(),
                        icon: Icons.person_2_rounded,
                        color: const Color(0xFF7B90FD),
                      ),
                      InfoCard(
                        title: 'Perempuan',
                        value: wanita.toString(),
                        icon: Icons.person_4,
                        color: const Color(0xFFF37575),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ContainerCard(
                    // title: 'Lokasi Indragiri',
                    // imagePath: 'assets/images/peta.png',
                    lat: -7.130000,
                    leng: 107.340000,
                    zoom: 13.0,
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 3 / 2,
                    children: [
                      MenuCard(
                        icon: Icons.home,
                        title: 'Kebutuhan RW',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FAQ()),
                          );
                        },
                      ),
                      MenuCard(
                        icon: Icons.image,
                        title: 'Dokumentasi RW',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FAQ()),
                          );
                        },
                      ),
                      MenuCard(
                        icon: Icons.timeline,
                        title: 'Timeline Pengabdian',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Timeline()),
                          );
                        },
                      ),
                      MenuCard(
                        icon: Icons.history,
                        title: 'Histori Pengabdian',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => History()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            ContainerCardCarousel(
              title: 'Dokumentasi Desa',
              imagePaths: [
                'assets/images/dokumentasi.png',
                'assets/images/dokumentasi.png',
                'assets/images/dokumentasi.png',
              ],
            ),
          ],
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

class InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final Color color;

  const InfoCard({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: 160,
      decoration: BoxDecoration(
        color: color.withOpacity(1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: const Color.fromARGB(255, 49, 49, 49),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Color(0xFFFFFFFF)),
          ),
          Text(
            value,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF)),
          ),
        ],
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
      padding: const EdgeInsets.all(8),
      width: 380,
      height: 237,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
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

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MenuCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        height: 190,
        decoration: BoxDecoration(
          color: const Color(0xFF60AD77),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: const Color.fromARGB(255, 49, 49, 49)),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
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
        color: const Color(0xFFC5E0CD),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
