import 'package:flutter/material.dart';

import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

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
  int _selectedIndex = 0;

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
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Masukkan nomor telepon',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'URL Tujuan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: 'Masukkan URL tujuan',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simpan perubahan dan kembali ke halaman sebelumnya
                Navigator.pop(context, {
                  'contactNumber': _numberController.text,
                  'contactName': _nameController.text,
                  'contactUrl': _urlController.text,
                });
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

  @override
  void dispose() {
    _numberController.dispose();
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }
}
