import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Auth/AuthServices.dart';
import 'package:flutter_helloo_world/Auth/daftar.dart';
import 'package:flutter_helloo_world/Dashboard.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _email;
  late TextEditingController _password;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 100, // Ukuran besar icon person
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                ),
                controller: _email,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                obscureText: true, // Masking untuk password
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
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
            SizedBox(height: 60, width: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  await handleLogin(email, password);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(
                      0xFF60AD77), // Mengatur warna latar belakang tombol menjadi hijau
                  minimumSize: Size(
                      double.infinity, 50), // Mengatur lebar dan tinggi tombol
                ),
                child: Text('Login', style: TextStyle(color: Colors.black)),
              ),
            ),
            SizedBox(height: 40),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Daftar()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFE9F0EB),
              ),
              child: Text('Belum mempunyai akun? DAFTAR',
                  style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> handleLogin(String email, String password) async {
    final userCredential = await AuthServices().login(email, password);
    if (userCredential != null) {
      // User logged in successfully,
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      log('Firebase Auth Error');
      // Login failed, display error message
    }
  }
}
