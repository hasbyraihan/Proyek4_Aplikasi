import 'package:flutter/material.dart';

class SetPopulasi extends StatefulWidget {
  @override
  _SetPopulasiState createState() => _SetPopulasiState();
}

class _SetPopulasiState extends State<SetPopulasi> {
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
      body: const Column(
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

          SizedBox(height: 30),
          // Tambahkan garis pembatas antara judul dan daftar dropdown
          RoundedInputField(
            hintText: "NIM",
            prefixIcon: Icon(Icons.people_sharp),
          ),
          SizedBox(height: 30),
          RoundedInputField(
            hintText: "NIM",
            prefixIcon: Icon(Icons.person_3_sharp),
          ),
          SizedBox(height: 30),
          RoundedInputField(
            hintText: "NIM",
            prefixIcon: Icon(Icons.person_4_sharp),
          ),
        ],
      ),
    );
  }
}

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final Icon prefixIcon;
  final bool obscureText;

  const RoundedInputField({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 312,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }
}
