import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminAddAkun.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:flutter_helloo_world/Models/UserDesa.dart' as user;

class AdminManageAkun extends StatefulWidget {
  @override
  _AdminManageAkunState createState() => _AdminManageAkunState();
}

class _AdminManageAkunState extends State<AdminManageAkun> {
  int _selectedIndex = 0;
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('Users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;

  // Tambahkan variabel untuk menyimpan kredensial pengguna yang sedang login
  late String currentUserEmail = 'admin@gmail.com';
  late String currentUserPassword = 'admin123';

  Stream<List<user.UserDesa>> getUsers() {
    return _database.onValue.map((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.entries
          .map((entry) => user.UserDesa.fromMap(
              Map<Object?, Object?>.from(entry.value), entry.key))
          .where((user) => user.role == 'admin')
          .toList();
    });
  }

  Future<void> deleteUser(String uid, String email, String password) async {
    try {
      // Sign in the user to be deleted
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      if (user != null && user.uid == uid) {
        // Delete from Firebase Realtime Database
        await _database.child(uid).remove();

        // Delete from Firebase Authentication
        await user.delete();
      }
    } catch (e) {
      print('Error deleting user: $e');
    } finally {
      // Sign out the user after deletion
      await _auth.signOut();

      try {
        // Sign back in with the original user's credentials
        await _auth.signInWithEmailAndPassword(
            email: currentUserEmail, password: currentUserPassword);
      } catch (e) {
        print('Error signing back in: $e');
        // Show a message to the user
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to sign back in. Please try again.'),
        ));
      }
    }
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
      body: StreamBuilder<List<user.UserDesa>>(
        stream: getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No admin users found.'));
          }
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: snapshot.data!.map((user.UserDesa user) {
              return CustomContainer(
                color: Color(0xFF60AD77),
                text: user.nama,
                additionalText: user.jabatan,
                icon1: Icons.edit,
                onTapIcon1: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddAkun()),
                  );
                },
                icon2: Icons.delete,
                onTapIcon2: () async {
                  String email = user.email; // Replace with the user's email
                  String password =
                      user.password; // Replace with the user's password
                  await deleteUser(user.uid, email, password);
                },
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tambahkan fungsi yang diinginkan di sini
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddAkun()), // Ganti dengan halaman yang sesuai
          );
        },
        backgroundColor: Color(0xFF60AD77), // Warna hijau
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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

class CustomContainer extends StatelessWidget {
  final Color color;
  final String text;
  final String additionalText;
  final IconData icon1;
  final VoidCallback onTapIcon1;
  final IconData icon2;
  final VoidCallback onTapIcon2;

  const CustomContainer({
    Key? key,
    required this.color,
    required this.text,
    required this.additionalText,
    required this.icon1,
    required this.onTapIcon1,
    required this.icon2,
    required this.onTapIcon2,
  }) : super(key: key);

  final double _width = 207; // Atur lebar container di sini
  final double _height = 130; // Atur tinggi container di sini

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            left: _width / 4 - 20,
            top: _height / 2 - 35,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: _width / 4 - 20,
            top: _height / 2 + 5,
            child: Text(
              additionalText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: _width +
                80, // Posisi ikon pada 1/4 bagian dari panjang container
            top: _height / 2 - 45,
            child: GestureDetector(
              onTap: onTapIcon1,
              child: Icon(
                icon1,
                size: 35,
                color: Color.fromARGB(255, 16, 80, 8),
              ),
            ),
          ),
          Positioned(
            left: _width +
                80, // Posisi ikon pada 1/4 bagian dari panjang container
            top: _height / 2 + 5,
            child: GestureDetector(
              onTap: onTapIcon2,
              child: Icon(
                icon2,
                size: 35,
                color: Color.fromARGB(255, 16, 80, 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
