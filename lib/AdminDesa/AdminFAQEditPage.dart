import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class AdminFAQEditPage extends StatefulWidget {
  @override
  _AdminFAQEditPageState createState() => _AdminFAQEditPageState();
}

class _AdminFAQEditPageState extends State<AdminFAQEditPage> {
  List<TextEditingController> questionControllers = [];
  List<TextEditingController> answerControllers = [];
  int _selectedIndex = 0;
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
        padding: EdgeInsets.all(16.0),
        children: [
          // Existing question and answer fields
          for (int i = 0; i < questionControllers.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: questionControllers[i],
                  decoration: InputDecoration(
                    labelText: 'Question ${i + 1}',
                  ),
                ),
                TextField(
                  controller: answerControllers[i],
                  decoration: InputDecoration(
                    labelText: 'Answer ${i + 1}',
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          // Button to add more fields
          ElevatedButton(
            onPressed: () {
              setState(() {
                questionControllers.add(TextEditingController());
                answerControllers.add(TextEditingController());
              });
            },
            child: Text('Tambah Pertanyaan'),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Implement logic to save edited FAQ here
            },
            child: Text('Simpan Perubahan'),
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

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in questionControllers) {
      controller.dispose();
    }
    for (var controller in answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
