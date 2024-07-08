import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Auth/AuthServices.dart';
import 'package:flutter_helloo_world/Auth/login.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Daftar extends StatefulWidget {
  @override
  _DaftarState createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> {
  late TextEditingController _namaController;
  late TextEditingController _nimController;
  late TextEditingController _perguruanTinggiController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _fotoController;
  late XFile? _image = null;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();
    _nimController = TextEditingController();
    _perguruanTinggiController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _fotoController = TextEditingController();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _perguruanTinggiController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fotoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
        _fotoController.text = image.path;
      });
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            InkWell(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(29),
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  children: [
                    Icon(Icons.photo_camera, color: Colors.black),
                    SizedBox(width: 20),
                    Text(
                      "Pas Foto 3x4 *Latar Belakang Biru",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _image == null
                ? Text('No image selected.')
                : Image.file(
                    File(_image!.path),
                    height: 100,
                  ),
            SizedBox(height: 20.0),
            RoundedInputField(
              hintText: "Nama",
              prefixIcon: Icon(Icons.person),
              controller: _namaController,
            ),
            SizedBox(height: 20.0),
            RoundedInputField(
              hintText: "NIM",
              prefixIcon: Icon(Icons.numbers_rounded),
              controller: _nimController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            RoundedInputField(
              hintText: "Perguruan Tinggi",
              prefixIcon: Icon(Icons.school),
              controller: _perguruanTinggiController,
            ),
            SizedBox(height: 20.0),
            RoundedInputField(
              hintText: "Email",
              prefixIcon: Icon(Icons.email),
              controller: _emailController,
            ),
            SizedBox(height: 20.0),
            RoundedPasswordField(
              hintText: "Password",
              prefixIcon: Icon(Icons.lock_outline),
              controller: _passwordController,
            ),
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                _Signup();
              },              
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff60ac76),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Daftar",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 40.0),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Sudah punya akun? ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'MASUK',
                      style: TextStyle(color: Colors.green),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
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
    );
  }

  _Signup() async {
    if (_namaController.text.isEmpty ||
        _nimController.text.isEmpty ||
        _perguruanTinggiController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _fotoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('isi dulu yaa temen temen'),
          backgroundColor: Colors.grey,
        ),
      );
      return;
    }

    try {
      await AuthServices().signup(
          _emailController.text,
          _passwordController.text,
          _namaController.text,
          _nimController.text,
          _perguruanTinggiController.text,
          _fotoController.text,
          "mahasiswa");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );

      // Handle successful signup (e.g., navigate to a confirmation screen)
    } catch (e) {
      // Display an error message to the user based on the exception type
      print('Error during signup: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mendaftar. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Icon prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;

  const RoundedInputField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 312,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }
}

class RoundedPasswordField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Icon prefixIcon;

  const RoundedPasswordField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 312,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }
}
