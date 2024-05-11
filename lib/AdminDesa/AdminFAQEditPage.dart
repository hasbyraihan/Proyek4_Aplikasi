import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class FAQItem {
  String? key;
  String question;
  String answer;

  FAQItem({this.key, required this.question, required this.answer});
}

class AdminFAQEditPage extends StatefulWidget {
  @override
  _AdminFAQEditPageState createState() => _AdminFAQEditPageState();
}

class _AdminFAQEditPageState extends State<AdminFAQEditPage> {
  final DatabaseReference faqRef = FirebaseDatabase.instance.ref().child('faq');
  List<FAQItem> faqItems = [];

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
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
          for (int i = 0; i < faqItems.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: TextEditingController(text: faqItems[i].question),
                  onChanged: (value) => faqItems[i].question = value,
                  decoration: InputDecoration(
                    labelText: 'Pertanyaan ${i + 1}',
                  ),
                ),
                TextField(
                  controller: TextEditingController(text: faqItems[i].answer),
                  onChanged: (value) => faqItems[i].answer = value,
                  decoration: InputDecoration(
                    labelText: 'Jawaban ${i + 1}',
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      faqItems.removeAt(i);
                    });
                  },
                  child: Text('Hapus Pertanyaan'),
                ),
              ],
            ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                faqItems.add(FAQItem(question: '', answer: ''));
              });
            },
            child: Text('Tambah Pertanyaan'),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              saveFAQsToFirebase();
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

  Future<void> saveFAQsToFirebase() async {
    try {
      for (var faq in faqItems) {
        if (faq.key == null) {
          final ref = await faqRef.push();
          await ref.set({
            'pertanyaan': faq.question,
            'jawab': faq.answer,
          });
          faq.key = ref.key;
        } else {
          await faqRef.child(faq.key!).set({
            'pertanyaan': faq.question,
            'jawab': faq.answer,
          });
        }
      }
    } catch (e) {
      print('Error saving FAQs: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
