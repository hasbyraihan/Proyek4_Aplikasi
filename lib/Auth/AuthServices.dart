// ignore_for_file: file_names

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> signup(String email, String password, String nama, String nim,
      String namaPerguruanTinggi, String fotoProfilPath, String role) async {
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
        role: role,
      );

      // Save user data to Realtime Database
      await _database.ref('/Users/$userId').set(user.toMap());

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
            .ref('/Users/$userId')
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', false);
    } catch (e) {
      // Handle potential errors during sign out (e.g., network issues)
      print('Error during logout: ${e.toString()}');
    }
  }

  Future<Map<Object?, Object?>?> getUserData(String userId) async {
    try {
      final userRef = FirebaseDatabase.instance.ref('/Users/$userId');
      final userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.value;
        if (userData != null) {
          // Allow for null data
          return userData as Map<Object?, Object?>; // Cast to desired type
        } else {
          print('Error: Unexpected user data format');
          return null;
        }
      } else {
        print('Error: User data not found in Realtime Database');
        return null;
      }
    } catch (error) {
      print('Error fetching user data: $error');
      return null; // Handle error appropriately
    }
  }
}

class User {
  final String uid;
  final String nama;
  final String nim;
  final String role;
  final String namaPerguruanTinggi;
  String fotoProfil;

  User({
    required this.uid,
    required this.nama,
    required this.nim,
    required this.namaPerguruanTinggi,
    this.fotoProfil = '',
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nama': nama,
      'nim': nim,
      'namaPerguruanTinggi': namaPerguruanTinggi,
      'role': role,
    };
  }
}
