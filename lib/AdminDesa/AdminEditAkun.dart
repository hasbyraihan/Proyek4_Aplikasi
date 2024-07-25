import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Auth/AuthServices.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_helloo_world/Models/UserDesa.dart'
    as userModel; // Rename the prefix to avoid conflict
import 'dart:io';

class EditAkun extends StatefulWidget {
  final userModel.UserDesa user; // Use the renamed prefix here

  EditAkun({required this.user});

  @override
  _EditAkunState createState() => _EditAkunState();
}

class _EditAkunState extends State<EditAkun> {
  late TextEditingController _namaController;
  late TextEditingController _nipController;
  late TextEditingController _jabatanController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _fotoController;
  late XFile? _image;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.user.nama);
    _nipController = TextEditingController(text: widget.user.nip);
    _jabatanController = TextEditingController(text: widget.user.jabatan);
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController(text: widget.user.password);
    _fotoController = TextEditingController(text: widget.user.fotoProfil);
    _image = null; // Initially, no new image is selected
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

  Future<void> _updateUser() async {
    // Call the updateAcc function with the new data
    await AuthServices().updateAcc(
      widget.user.uid,
      _emailController.text,
      _namaController.text,
      _nipController.text,
      _jabatanController.text,
      _fotoController.text,
      widget.user.role,
    );

    // After updating, navigate back or show a success message
    Navigator.pop(context);
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
              onPressed: _updateUser,
              child: Text(
                "Update",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
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
