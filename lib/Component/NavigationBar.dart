import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminDashboard.dart';
import 'package:flutter_helloo_world/Auth/login.dart';

import 'package:flutter_helloo_world/Mahasiswa/MahasiwaDashboard.dart';
import 'package:flutter_helloo_world/Models/User.dart' as user;
import 'package:flutter_helloo_world/pages/Dashboardbaru.dart';
import 'package:flutter_helloo_world/profil.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late int _selectedIndex;
  user.User? _user;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex.clamp(0, 2); 
    _loadUserData();
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardBaru()),
      );
    } else if (index == 1) {
      if (_user != null) {
        if (_user!.role == 'admin') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard()),
          );
        } else if (_user!.role == 'mahasiswa') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MahasiswaDashboard()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        }
      }
    } else if (index == 2) {
      if (_user != null && _user!.nama != 'Loading...') {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: _selectedIndex == 0
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Icon(Icons.home, color: Colors.white),
                      SizedBox(width: 4),
                      Text('Home', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                )
              : Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _selectedIndex == 1
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Icon(Icons.menu, color: Colors.white),
                      SizedBox(width: 4),
                      Text('Menu', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                )
              : Icon(Icons.menu),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _selectedIndex == 2
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.white),
                      SizedBox(width: 4),
                      Text('Profile', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                )
              : Icon(Icons.person),
          label: '',
        ),
      ],
    );
  }
}
