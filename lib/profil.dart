import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Auth/AuthServices.dart';
import 'package:flutter_helloo_world/Dashboard.dart';
import 'package:flutter_helloo_world/Models/User.dart' as user;
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  late user.User _user; // Mendeklarasikan _user

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Memuat data pengguna saat widget diinisialisasi
  }

  Future<void> _loadUserData() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        setState(() {
          _user = user.User.loading();
        });

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
    } catch (e) {
      print('Error: Failed to load user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    return Scaffold(
      appBar: AppBar(
          // Kode app bar...
          ),
      backgroundColor: Color(0xFFE9F0EB),
      body: Center(
        child: _user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _user.fotoProfil.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(_user.fotoProfil),
                          radius: 50,
                        )
                      : Icon(
                          Icons.person,
                          size: 100,
                        ),
                  SizedBox(height: 20),
                  Text('${_user.nama}'),
                  Text('${_user.nim}'),
                  Text(
                    ' ${_user.namaPerguruanTinggi}',
                  ),
                  SizedBox(height: 60, width: 40),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: ElevatedButton(
                      onPressed: () {
                        handleLogout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF60AD77),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child:
                          Text('Logout', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              )
            : CircularProgressIndicator(), // Loading indicator saat memuat data
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

  Future<void> handleLogout() async {
    try {
      await AuthServices().logout();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } catch (e) {
      print('Firebase Auth Error: ${e}');
    }
  }
}
