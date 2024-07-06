import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import library untuk membuka URL
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_helloo_world/Mahasiswa/MahasiwaDashboard.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class ContactPerson extends StatefulWidget {
  @override
  _ContactPersonState createState() => _ContactPersonState();
}

class Contact_Person {
  final String name;
  final String phoneNumber;
  final String url;

  Contact_Person({
    required this.name,
    required this.phoneNumber,
    required this.url,
  });
}

class _ContactPersonState extends State<ContactPerson> {
  int _selectedIndex = 1;
  Contact_Person? _contactPerson;

  @override
  void initState() {
    super.initState();
    _getContactPerson();
  }

  Future<void> _getContactPerson() async {
    final userRef = FirebaseDatabase.instance.ref('contact-person');
    final snapshot = await userRef.get();

    if (snapshot.value != null) {
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _contactPerson = Contact_Person(
          name: data['contactName'] ?? '',
          phoneNumber: data['contactNumber'] ?? '',
          url: data['contactUrl'] ?? '',
        );
      });
    }
  }

  void navigateToDashboard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MahasiswaDashboard()),
    );
  }

  // Fungsi untuk membuka link
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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
      body: _contactPerson != null
          ? ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Item kedua
                ContactItem(
                  color: Color(0xFFE9F0EB),
                  icon: Icons.phone,
                  text: _contactPerson!.phoneNumber,
                  name: _contactPerson!.name,
                ),

                // Tombol untuk membuka link
                ElevatedButton(
                  onPressed: () {
                    _launchURL(_contactPerson!.url);
                  },
                  child: Text('Visit Website'),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
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

class ContactItem extends StatelessWidget {
  final String text;
  final String name;
  final IconData icon;
  final Color color;

  const ContactItem({
    Key? key,
    required this.text,
    required this.icon,
    required this.color,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.black, // Atur warna ikon sesuai kebutuhan
          ),
          SizedBox(height: 80), // Spacer vertikal antara ikon dan teks
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
