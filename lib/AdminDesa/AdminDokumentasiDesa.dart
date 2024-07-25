import 'package:flutter/material.dart';

import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';

class AdminDokumentasiDesa extends StatefulWidget {
  @override
  _AdminDokumentasiDesaState createState() => _AdminDokumentasiDesaState();
}

class _AdminDokumentasiDesaState extends State<AdminDokumentasiDesa> {
  int _selectedIndex = 0;

  final picker = ImagePicker();
  File? _image;
  bool _isUploading = false;
  List<Map<String, String>> _images = [];

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    final databaseReference =
        FirebaseDatabase.instance.ref().child('info-desa/dokumentasi-desa/');

    final snapshot = await databaseReference.get();

    final List<Map<String, String>> fetchedImages = [];
    if (snapshot.exists) {
      Map<dynamic, dynamic> imagesMap = snapshot.value as Map<dynamic, dynamic>;
      imagesMap.forEach((key, value) {
        fetchedImages.add({'key': key, 'imageUrl': value['imageUrl']});
      });
    }

    setState(() {
      _images = fetchedImages;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Get a reference to the Firebase Storage bucket
      final storageReference = FirebaseStorage.instance.ref().child(
          'info-desa/dokumentasi-desa/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the file to Firebase Storage
      final uploadTask = storageReference.putFile(_image!);

      // Wait for the upload to complete
      final snapshot = await uploadTask.whenComplete(() {});

      // Get the download URL of the uploaded file
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Save the download URL to Firebase Realtime Database
      final databaseReference = FirebaseDatabase.instance
          .ref()
          .child('info-desa/dokumentasi-desa')
          .push();

      await databaseReference.set({'imageUrl': downloadUrl});

      setState(() {
        _isUploading = false;
        _image = null;
      });

      // Update state
      await _fetchImages(); // Untuk memuat ulang gambar yang ada

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image uploaded successfully!')),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  Future<void> _deleteImage(String key, String imageUrl) async {
    setState(() {
      _isUploading = true;
    });

    try {
      // Hapus gambar dari Firebase Storage
      final storageReference = FirebaseStorage.instance.refFromURL(imageUrl);
      await storageReference.delete();

      // Hapus data gambar dari Firebase Realtime Database
      final databaseReference = FirebaseDatabase.instance
          .ref()
          .child('info-desa/dokumentasi-desa')
          .child(key);
      await databaseReference.remove();

      // Update state
      await _fetchImages(); // Untuk memuat ulang gambar yang ada

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete image: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(imageUrl),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC5E0CD),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Image.asset(
              'assets/images/logo.png',
              width: 54,
              height: 52,
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // mengatur posisi bayangan
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image == null
                  ? Text('')
                  : Image.file(_image!, height: 200, width: 200),
              SizedBox(height: 20),
              _isUploading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Tambah Foto'),
                    ),
              SizedBox(height: 20),
              _image != null && !_isUploading
                  ? ElevatedButton(
                      onPressed: _uploadImage,
                      child: Text('Kirimkan Foto'),
                    )
                  : Container(),
              SizedBox(height: 20),
              // Mengganti Column dengan ListView
              Expanded(
                child: ListView.builder(
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    final image = _images[index];
                    final imageKey = image['key']!;
                    final imageUrl = image['imageUrl']!;

                    return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Gambar ke - ${index + 1}', // Menampilkan Gambar ke - {increment}
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.visibility, color: Colors.yellow),
                            onPressed: () => _showImage(imageUrl),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteImage(imageKey, imageUrl),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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
}
