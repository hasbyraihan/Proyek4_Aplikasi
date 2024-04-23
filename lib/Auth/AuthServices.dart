// ignore_for_file: file_names

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> signup(String email, String password, String nama, String nim,
      String namaPerguruanTinggi, String fotoProfilPath) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = credential.user!.uid;

      final user = User(
        uid: userId,
        nama: nama,
        nim: nim,
        namaPerguruanTinggi: namaPerguruanTinggi,
        fotoProfil: '', // Placeholder for later URL retrieval
      );

      // Save user data to Realtime Database
      await _database.ref('/Users-Mahasiswa/$userId').set(user.toMap());

      // Upload foto profil (if provided)
      if (fotoProfilPath.isNotEmpty) {
        final storageRef =
            _storage.ref('/user-profile-images/$userId-fotoProfil.jpg');
        final fotoProfilFile = File(
            fotoProfilPath); // Assuming fotoProfilPath leads to a valid file

        await storageRef.putFile(fotoProfilFile);

        // Update fotoProfilURL after successful upload
        final fotoProfilURL = await storageRef.getDownloadURL();
        user.fotoProfil = fotoProfilURL;

        // Optionally, update user data in Realtime Database with the URL
        await _database
            .ref('/Users-Mahasiswa/$userId')
            .update({'fotoProfilURL': fotoProfilURL});
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException appropriately (e.g., display error message)
      print('Firebase Auth Error: ${e.code}');
    } catch (e) {
      // Handle other potential errors (e.g., network issues, storage errors)
      print('Error during signup: ${e.toString()}');
    }
  }

  Future<UserCredential?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException appropriately (e.g., display error message)
      print('Firebase Auth Error: ${e.code}');
      return null;
    } catch (e) {
      // Handle other potential errors (e.g., network issues)
      print('Error during login: ${e.toString()}');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // Handle potential errors during sign out (e.g., network issues)
      print('Error during logout: ${e.toString()}');
    }
  }
}

class User {
  final String uid;
  final String nama;
  final String nim;
  final String namaPerguruanTinggi;
  String fotoProfil;

  User({
    required this.uid,
    required this.nama,
    required this.nim,
    required this.namaPerguruanTinggi,
    this.fotoProfil = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nama': nama,
      'nim': nim,
      'namaPerguruanTinggi': namaPerguruanTinggi,
    };
  }
}
