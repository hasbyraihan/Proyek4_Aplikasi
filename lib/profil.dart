import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Auth/AuthServices.dart';
import 'package:flutter_helloo_world/Mahasiswa/KegiatanPengabdian.dart';
import 'package:flutter_helloo_world/Models/User.dart' as user;
import 'package:flutter_helloo_world/Models/UserDesa.dart' as userDesa;
import 'package:flutter_helloo_world/Faq.dart';
import 'package:flutter_helloo_world/Mahasiswa/ContactPerson.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:flutter_helloo_world/pages/Dashboardbaru.dart';
import 'package:image_picker/image_picker.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  dynamic _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

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

          setState(() {
            if (userRole == 'mahasiswa') {
              _user = user.User.fromMap(userData);
            } else if (userRole == 'admin') {
              _user = userDesa.UserDesa.fromMap(userData, userId);
            } else {
              print('Error: User role is invalid or not supported');
            }
            _isLoading = false;
          });
        } else {
          print('Error: User data is null');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('Error: No user currently logged in');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error: Failed to load user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _changeProfilePhoto() async {
    try {
      final ImagePicker _picker = ImagePicker();
      // Pick an image from gallery
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final bool? isConfirmed = await _showConfirmationDialog(image.path);

        if (isConfirmed == true) {
          final firebaseUser = FirebaseAuth.instance.currentUser;
          if (firebaseUser != null) {
            final userId = firebaseUser.uid;
            final fileName = '$userId/profile_picture.png';

            // Upload image to Firebase Storage
            final storageRef = FirebaseStorage.instance.ref().child('profile_pictures/$fileName');
            final uploadTask = storageRef.putFile(File(image.path));

            final snapshot = await uploadTask;
            final downloadUrl = await snapshot.ref.getDownloadURL();

            // Update user profile photo URL in Firebase Realtime Database
            final userRef = FirebaseDatabase.instance.ref('/Users/$userId');
            await userRef.update({'fotoProfilURL': downloadUrl});

            // Update UI with the new photo URL
            setState(() {
              _user.fotoProfil = downloadUrl;
            });

            print('Profile photo updated successfully!');
          }
        } else {
          print('User cancelled photo change.');
        }
      }
    } catch (e) {
      print('Error while updating profile photo: $e');
    }
  }

  Future<bool?> _showConfirmationDialog(String imagePath) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Peringatan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 3), // Border lingkaran
                ),
                child: ClipOval(
                  child: Image.file(
                    File(imagePath), // Menampilkan gambar yang dipilih
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text("Yakin mau ganti fotonya kaya gini?"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User memilih 'Tidak'
              },
              child: Text("Tidak", style: TextStyle(color: Colors.green),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User memilih 'Ya'
              },
              child: Text("Ya", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 3;
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
                );
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _user != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
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
                              _changeProfilePhoto();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF60AD77),
                              minimumSize: Size(double.infinity, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text('Edit Foto',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
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
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                if (_user.role == 'mahasiswa') ...[
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
                                ] else if (_user.role == 'admin') ...[
                                  Text(
                                    '${_user.nip}',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '${_user.jabatan}',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ]
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
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text('Logout',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                        ),
                        SizedBox(height: 20),
                        if (_user.role == 'mahasiswa') ...[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          KegiatanPengabdian()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF60AD77),
                                minimumSize: Size(double.infinity, 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text('Kegiatan Pengabdian',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactPerson()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF60AD77),
                              minimumSize: Size(double.infinity, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text('Orang yang dapat dihubungi',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    'User data not available',
                    style: TextStyle(fontSize: 20),
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

  Future<void> handleLogout() async {
    try {
      await AuthServices().logout();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardBaru()),
      );
    } catch (e) {
      print('Firebase Auth Error: $e');
    }
  }
}
