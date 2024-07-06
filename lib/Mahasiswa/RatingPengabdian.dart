import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_helloo_world/Mahasiswa/MahasiwaDashboard.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class RatingPengabdian extends StatefulWidget {
  final String pengabdianId;

  RatingPengabdian({required this.pengabdianId});

  @override
  _RatingPengabdianState createState() => _RatingPengabdianState();
}

class _RatingPengabdianState extends State<RatingPengabdian> {
  int _selectedIndex = 1;
  late DatabaseReference _databaseReference;
  String _evaluasi = '';
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance
        .ref()
        .child('evaluasi')
        .child(widget.pengabdianId);
    _fetchEvaluasiData();
  }

  void _fetchEvaluasiData() async {
    try {
      DataSnapshot snapshot = await _databaseReference.get();
      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _rating = data['rating'];
          _evaluasi = data['evaluasi'];
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void navigateToDashboard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MahasiswaDashboard()),
    );
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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          RatingContainer(
            color: Color.fromARGB(255, 255, 255, 255),
            text: 'Rating',
            rating: _rating,
          ),
          SizedBox(height: 20),
          CustomContainer(
            color: Color.fromARGB(255, 255, 255, 255),
            text: 'Evaluasi',
            description: _evaluasi,
          ),
        ],
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

class RatingContainer extends StatelessWidget {
  final String text;

  final Color color;
  final int rating;

  const RatingContainer({
    Key? key,
    required this.text,
    required this.color,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 1,
            color: Colors.black,
            margin: EdgeInsets.symmetric(vertical: 5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: index < rating ? Colors.orange : Colors.orange,
                size: 30,
              );
            }),
          ),
        ],
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String text;
  final String description;
  final Color color;

  const CustomContainer({
    Key? key,
    required this.text,
    required this.description,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 1,
            color: Colors.black,
            margin: EdgeInsets.symmetric(vertical: 5),
          ),
          Text(
            description,
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
