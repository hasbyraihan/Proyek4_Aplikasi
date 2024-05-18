import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminDashboard.dart';
import 'package:flutter_helloo_world/Auth/login.dart';
import 'package:flutter_helloo_world/Dashboard.dart';
import 'package:flutter_helloo_world/History.dart';
import 'package:flutter_helloo_world/Mahasiswa/MahasiwaDashboard.dart';
import 'package:flutter_helloo_world/Timeline.dart';
import 'package:flutter_helloo_world/profil.dart';
import 'package:flutter_helloo_world/Models/User.dart' as user;
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { admin, mahasiswa }

class NavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _selectedIndex = 0;

  late user.User _user; // Mendeklarasikan _user

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Memuat data pengguna saat widget diinisialisasi
  }

  Future<void> _loadUserData() async {
    try {
      final isLoggedIn = await _checkUserLoggedIn();

      if (isLoggedIn) {
        final firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser != null) {
          final userId = firebaseUser.uid;
          final userRef = FirebaseDatabase.instance.ref('/Users/$userId');
          final userSnapshot = await userRef.get();

          final userData = userSnapshot.value as Map<Object?, Object?>?;

          if (userData != null) {
            setState(() {
              _user = user.User.fromMap(userData);
            });
          } else {
            print('Error: User data is null');
          }
        } else {
          print('Error: No user currently logged in');
        }
      } else {
        setState(() {
          _user = user.User.loading();
        });
        print('Error: User not logged in');
      }
    } catch (e) {
      print('Error: Failed to load user data: $e');
    }
  }

  Future<bool> _checkUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      
      onTap: (index) {
        // Navigasi ke halaman yang sesuai berdasarkan index
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          ).then((_) {
            // Setelah navigasi selesai, perbarui _selectedIndex jika diperlukan
            setState(() {
              _selectedIndex = index;
            });
          });
        } else {
          // Implementasi navigasi ke halaman lain jika diperlukan
          widget.onTap(index); // Panggil onTap dari widget induk
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // Fungsi untuk menangani ketika item "Home" ditekan
              if (_user != null && _user.nama != 'Loading...') {
                // Periksa apakah _user sudah diinisialisasi dengan data pengguna yang valid
                if (_user.role == 'admin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminDashboard()),
                  );
                } else if (_user.role == 'mahasiswa') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MahasiswaDashboard()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );
                }
              } else {
                // Tunggu hingga data pengguna dimuat sebelum menavigasi
                // Atau tampilkan pesan kesalahan
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
                print('Error: User data is not yet loaded');
              }
            },
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Timeline()),
              );
            },
          ),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => History()),
              );
            },
          ),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              if (_user != null && _user.nama != 'Loading...') {
                // Periksa apakah _user sudah diinisialisasi dengan data pengguna yang valid
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profil()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              }
            },
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
