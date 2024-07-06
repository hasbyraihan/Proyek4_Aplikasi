import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class AdminFaqEditPage extends StatefulWidget {
  @override
  _AdminFaqEditPageState createState() => _AdminFaqEditPageState();
}

class FAQItem {
  final String key;
  final String question;
  final String answer;

  FAQItem({required this.key, required this.question, required this.answer});
}

class _AdminFaqEditPageState extends State<AdminFaqEditPage> {
  final DatabaseReference _faqRef = FirebaseDatabase.instance.ref('faq');
  int _selectedIndex = 1;

  Future<List<FAQItem>> fetchFAQFromFirebase() async {
    List<FAQItem> faqList = [];
    try {
      final snapshot = await _faqRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          final question = value['pertanyaan'] ?? '';
          final answer = value['jawab'] ?? '';
          faqList.add(FAQItem(key: key, question: question, answer: answer));
        });
      }
    } catch (e) {
      print('Error fetching FAQ: $e');
    }
    return faqList;
  }

  Future<void> _addFAQ(String question, String answer) async {
    try {
      final newFaqRef = _faqRef.push();
      await newFaqRef.set({
        'pertanyaan': question,
        'jawab': answer,
      });
    } catch (e) {
      print('Error adding FAQ: $e');
    }
  }

  Future<void> _updateFAQ(String key, String question, String answer) async {
    try {
      await _faqRef.child(key).update({
        'pertanyaan': question,
        'jawab': answer,
      });
    } catch (e) {
      print('Error updating FAQ: $e');
    }
  }

  Future<void> _deleteFAQ(String key) async {
    try {
      await _faqRef.child(key).remove();
    } catch (e) {
      print('Error deleting FAQ: $e');
    }
  }

  void _showEditDialog(FAQItem faq) {
    final TextEditingController questionController =
        TextEditingController(text: faq.question);
    final TextEditingController answerController =
        TextEditingController(text: faq.answer);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit FAQ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: InputDecoration(labelText: 'Pertanyaan'),
              ),
              TextField(
                controller: answerController,
                decoration: InputDecoration(labelText: 'Jawaban'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateFAQ(
                    faq.key, questionController.text, answerController.text);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog() {
    final TextEditingController questionController = TextEditingController();
    final TextEditingController answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add FAQ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: InputDecoration(labelText: 'Pertanyaan'),
              ),
              TextField(
                controller: answerController,
                decoration: InputDecoration(labelText: 'Jawaban'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addFAQ(questionController.text, answerController.text);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text('Add'),
            ),
          ],
        );
      },
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
      body: FutureBuilder<List<FAQItem>>(
        future: fetchFAQFromFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text('Error fetching FAQ'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final faq = snapshot.data![index];
                return ListTile(
                  title: Text(faq.question),
                  subtitle: Text(faq.answer),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(faq);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteFAQ(faq.key);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFC5E0CD),
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
