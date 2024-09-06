import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminAddAkun.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminEditAkun.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:flutter_helloo_world/Models/UserDesa.dart' as userModel;

class AdminManageAkun extends StatefulWidget {
  @override
  _AdminManageAkunState createState() => _AdminManageAkunState();
}

class _AdminManageAkunState extends State<AdminManageAkun> {
  int _selectedIndex = 1;
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('Users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;

  // Tambahkan variabel untuk menyimpan kredensial pengguna yang sedang login
  late String currentUserEmail = 'admin@gmail.com';
  late String currentUserPassword = 'admin123';

  Stream<List<userModel.UserDesa>> getUsers() {
    return _database.onValue.map((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.entries
          .map((entry) => userModel.UserDesa.fromMap(
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
      body: StreamBuilder<List<userModel.UserDesa>>(
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
            children: snapshot.data!.map((userModel.UserDesa userData) {
              return CustomContainer(
                color: Color(0xFF60AD77),
                text: userData.nama,
                additionalText: userData.jabatan,
                icon1: Icons.edit,
                onTapIcon1: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditAkun(user: userData)),
                  );
                },
                icon2: Icons.delete,
                onTapIcon2: () async {
                  String email =
                      userData.email; // Replace with the user's email
                  String password =
                      userData.password; // Replace with the user's password
                  await deleteUser(userData.uid, email, password);
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

  @override
  Widget build(BuildContext context) {
    // Menggunakan MediaQuery untuk menyesuaikan ukuran container berdasarkan ukuran layar
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double containerWidth = screenWidth * 0.9; // 90% dari lebar layar
    double containerHeight = screenHeight * 0.13; // 13% dari tinggi layar

    return Container(
      width: containerWidth,
      height: containerHeight,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding:
          EdgeInsets.all(16), // Tambahkan padding untuk tampilan lebih rapi
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Membuat jarak antar elemen
        children: [
          // Teks utama dan teks tambahan dalam satu Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment
                .center, // Agar teks berada di tengah secara vertikal
            children: [
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth *
                      0.06, // Sesuaikan ukuran teks dengan lebar layar
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5), // Jarak antara teks utama dan teks tambahan
              Text(
                additionalText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      screenWidth * 0.05, // Ukuran lebih kecil dari teks utama
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Dua ikon di dalam Column
          Column(
            mainAxisAlignment: MainAxisAlignment
                .center, // Agar ikon berada di tengah secara vertikal
            children: [
              GestureDetector(
                onTap: onTapIcon1,
                child: Icon(
                  icon1,
                  size: screenWidth *
                      0.07, // Sesuaikan ukuran ikon dengan lebar layar
                  color: Color.fromARGB(255, 16, 80, 8),
                ),
              ),
              SizedBox(height: 10), // Jarak antara dua ikon
              GestureDetector(
                onTap: onTapIcon2,
                child: Icon(
                  icon2,
                  size: screenWidth *
                      0.07, // Sesuaikan ukuran ikon dengan lebar layar
                  color: Color.fromARGB(255, 16, 80, 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
