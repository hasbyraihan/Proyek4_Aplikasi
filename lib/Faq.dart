import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FAQ extends StatefulWidget {
  @override
  _FAQState createState() => _FAQState();
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class _FAQState extends State<FAQ> {
  Future<List<FAQItem>> fetchFAQFromFirebase() async {
    List<FAQItem> faqList = [];
    try {
      final userRef = FirebaseDatabase.instance.ref('faq');
      final snapshot = await userRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          final question = value['pertanyaan'] ?? '';
          final answer = value['jawab'] ?? '';
          faqList.add(FAQItem(question: question, answer: answer));
        });
      }
    } catch (e) {
      print('Error fetching FAQ: $e');
    }
    return faqList;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Pertanyaan yang Sering Ditanyakan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<FAQItem>>(
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
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                        title: Text(snapshot.data![index].question),
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              snapshot.data![index].answer,
                              textAlign: TextAlign
                                  .start, // Mengatur penempatan teks ke kiri
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
