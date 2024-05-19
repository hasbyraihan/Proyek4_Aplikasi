import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/AdminDesa/AdminManageAkun.dart';
import 'package:flutter_helloo_world/Auth/AuthServices.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddAkun extends StatefulWidget {
  @override
  _AddAkunState createState() => _AddAkunState();
}

class _AddAkunState extends State<AddAkun> {
  late TextEditingController _namaController;
  late TextEditingController _nipController;
  late TextEditingController _jabatanController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _fotoController;
  late XFile? _image = null;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();
    _nipController = TextEditingController();
    _jabatanController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _fotoController = TextEditingController();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nipController.dispose();
    _jabatanController.dispose();
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
              hintText: "NIP",
              prefixIcon: Icon(Icons.numbers_rounded),
              controller: _nipController,
            ),
            SizedBox(height: 20.0),
            RoundedInputField(
              hintText: "Jabatan",
              prefixIcon: Icon(Icons.school),
              controller: _jabatanController,
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
              prefixIcon: Icon(Icons.key),
              controller: _passwordController,
            ),
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                _Signup();
              },
              child: Text(
                "Daftar",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _Signup() async {
    try {
      await AuthServices().addAcc(
          _emailController.text,
          _passwordController.text,
          _namaController.text,
          _nipController.text,
          _jabatanController.text,
          _fotoController.text,
          "admin" // Assuming _fotoController holds the image path
          );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminManageAkun()),
      );

      // Handle successful signup (e.g., navigate to a confirmation screen)
    } catch (e) {
      // Display an error message to the user based on the exception type
      print('Error during signup: $e');
    }
  }
}

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Icon prefixIcon;
  final bool obscureText;

  const RoundedInputField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.prefixIcon,
    this.obscureText = false,
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
