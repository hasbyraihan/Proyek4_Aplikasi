import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Auth/AuthServices.dart';
import 'package:flutter_helloo_world/Dashboard.dart';
import 'package:flutter_helloo_world/Models/User.dart' as user;
import 'package:flutter_helloo_world/Faq.dart';
import 'package:flutter_helloo_world/Mahasiswa/ContactPerson.dart';
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
      body: _user != null
          ? Padding(
              padding: const EdgeInsets.only(
                  top: 50.0), // Push content towards the top
              child: Column(
                children: [
                  _user.fotoProfil.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(_user.fotoProfil),
                          radius: 100,
                        )
                      : Icon(
                          Icons.person,
                          size: 100,
                        ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 120),
                    child: ElevatedButton(
                      onPressed: () {

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF60AD77),
                        minimumSize: Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // More square shape
                        ),
                      ),
                      child: Text('Edit Foto',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20), // Horizontal padding
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${_user.nama}',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${_user.nim}',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${_user.namaPerguruanTinggi}',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        handleLogout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF60AD77),
                        minimumSize: Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // More square shape
                        ),
                      ),
                      child: Text('Logout',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FAQ()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF60AD77),
                        minimumSize: Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // More square shape
                        ),
                      ),
                      child: Text('Kegiatan Pengabdian',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ContactPerson()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF60AD77),
                        minimumSize: Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // More square shape
                        ),
                      ),
                      child: Text('Orang yang dapat dihubungi',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child:
                  CircularProgressIndicator(), // Loading indicator when data is loading
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
