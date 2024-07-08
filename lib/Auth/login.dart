import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminDashboard.dart';
import 'package:flutter_helloo_world/Auth/AuthServices.dart';
import 'package:flutter_helloo_world/Auth/daftar.dart';
import 'package:flutter_helloo_world/Mahasiswa/MahasiwaDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { admin, mahasiswa }

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _email;
  late TextEditingController _password;
  bool _emailError = false;
  bool _passwordError = false;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Icon(
                Icons.person,
                size: 100, // Ukuran besar icon person
              ),
              SizedBox(height: 40),
               Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(                    
                    prefixIcon: Icon(Icons.email),
                    iconColor: Colors.grey,
                    labelText: 'Email',
                    errorText: _emailError ? 'Invalid email' : null,
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  controller: _email,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  obscureText: true, // Masking untuk password
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    iconColor: Colors.grey,
                    labelText: 'Password',
                    errorText: _passwordError ? 'Invalid password' : null,
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  controller: _password,
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Fungsi untuk navigasi ke halaman lupa password
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFE9F0EB),
                ),
                child: Text('Lupa Kata Sandi?',
                    style: TextStyle(color: Colors.green)),
              ),
              SizedBox(height: 40, width: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    await handleLogin(email, password);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF60AD77),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                  ),
                  child: Text(
                    'Login', 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700
                    )
                  ),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child : RichText(
                  text: TextSpan(
                    text: 'Belum punya akun? ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: 'DAFTAR',
                        style: TextStyle(color: Colors.green),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Daftar()),
                            );
                          },
                      ),
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleLogin(String email, String password) async {
    setState(() {
      _emailError = false;
      _passwordError = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          Center(child: CircularProgressIndicator()),
    );

    final userCredential = await AuthServices().login(email, password);
    Navigator.pop(context);

    if (userCredential != null) {
      // Get the logged-in user's UID from the userCredential object
      final userId = userCredential.user!.uid;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);

      // Fetch user data (including role) from Firebase (replace with your implementation)
      final userData = await AuthServices()
          .getUserData(userId); // Replace _getUserData with your code

      if (userData != null && userData['role'] != null) {
        final userRole = UserRole.values.byName(userData['role'] as String);

        // Show success notification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil Login :)'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate based on user role after the SnackBar duration
        Future.delayed(Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              if (userRole == UserRole.admin) {
                return AdminDashboard();
              } else {
                return MahasiswaDashboard();
              }
            }),
          );
        });
      } else {
        print('Error: Failed to retrieve user data or role is missing');
        // Handle error (e.g., display message to user)
      }
    } else {
      log('Firebase Auth Error');
      setState(() {
        _emailError = true;
        _passwordError = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ada yang salah gaes:('),
            duration: Duration(seconds: 2),
          ),
        );
    }
  }
}
