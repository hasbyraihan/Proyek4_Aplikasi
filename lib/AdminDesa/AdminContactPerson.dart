import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;
import 'package:firebase_database/firebase_database.dart';

class AdminContactPerson extends StatefulWidget {
  final String contactNumber;
  final String contactName;
  final String contactUrl;

  const AdminContactPerson({
    Key? key,
    required this.contactNumber,
    required this.contactName,
    required this.contactUrl,
  }) : super(key: key);

  @override
  _AdminContactPersonState createState() => _AdminContactPersonState();
}

class _AdminContactPersonState extends State<AdminContactPerson> {
  late TextEditingController _numberController;
  late TextEditingController _nameController;
  late TextEditingController _urlController;
  int _selectedIndex = 1;

  final DatabaseReference contactRef =
      FirebaseDatabase.instance.ref().child('contact-person');

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController(text: widget.contactNumber);
    _nameController = TextEditingController(text: widget.contactName);
    _urlController = TextEditingController(text: widget.contactUrl);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Nama',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Nomor Telepon',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '+62 ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _numberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nomor telepon',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                saveContactInfoToFirebase();
              },
              child: Text('Simpan Perubahan'),
            ),
          ],
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

  void saveContactInfoToFirebase() async {
    try {
      final Map<String, dynamic> contactInfo = {
        'contactNumber': '0${_numberController.text}',
        'contactName': _nameController.text,
        'contactUrl':
            'https://wa.me/62${_numberController.text}', // WhatsApp URL
      };

      await contactRef.update(contactInfo);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Informasi kontak berhasil diperbarui.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }
}
