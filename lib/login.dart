import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                  hintText: 'Username',
                  labelText: 'Username',
                ),
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
                onPressed: () {
                  // Fungsi untuk login
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
                // Fungsi untuk navigasi ke halaman lupa password
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFE9F0EB),
              ),
              child: Text(
                  'Belum mempunyai akun? DAFTAR',
                  style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
      ),
    );
  }
}
