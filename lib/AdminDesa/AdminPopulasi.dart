import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class AdminPopulasi extends StatefulWidget {
  @override
  _AdminPopulasiState createState() => _AdminPopulasiState();
}

class _AdminPopulasiState extends State<AdminPopulasi> {
  int _selectedIndex = 0;
  late TextEditingController _malePopulationController;
  late TextEditingController _femalePopulationController;
  int _malePopulation = 0;
  int _femalePopulation = 0;

  @override
  void initState() {
    super.initState();
    _malePopulationController = TextEditingController();
    _femalePopulationController = TextEditingController();
  }

  @override
  void dispose() {
    _malePopulationController.dispose();
    _femalePopulationController.dispose();
    super.dispose();
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
          SizedBox(height: 20),
          RoundedInputField(
            hintText: "Laki Laki",
            prefixIcon: Icon(Icons.person_3_outlined),
            controller: _malePopulationController,
            onChanged: (value) {
              setState(() {
                _malePopulation = int.tryParse(value) ?? 0;
              });
            },
          ),
          SizedBox(height: 20),
          RoundedInputField(
            hintText: "Perempuan",
            prefixIcon: Icon(Icons.person_4_outlined),
            controller: _femalePopulationController,
            onChanged: (value) {
              setState(() {
                _femalePopulation = int.tryParse(value) ?? 0;
              });
            },
          ),
          SizedBox(height: 30),
          ContainerCardPopulation(
            title: 'Populasi Warga',
            malePopulation: _malePopulation,
            femalePopulation: _femalePopulation,
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Populasi Laki-laki: $_malePopulation',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Populasi Perempuan: $_femalePopulation',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Total Populasi: ${_malePopulation + _femalePopulation}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Implementasi logika untuk menyimpan data ke database atau melakukan validasi
                  },
                  child: Text(
                    "Simpan",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
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

class ContainerCardPopulation extends StatelessWidget {
  final String title;
  final int malePopulation;
  final int femalePopulation;

  const ContainerCardPopulation({
    Key? key,
    required this.title,
    required this.malePopulation,
    required this.femalePopulation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalPopulation = malePopulation + femalePopulation;

    return Container(
      width: 380,
      height: 237,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Column(
              children: [
                _buildPopulationBox(
                    'Total', totalPopulation, Color(0xFF60AD77)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPopulationBox(
                        'Laki-laki', malePopulation, Color(0xFF60AD77)),
                    _buildPopulationBox(
                        'Perempuan', femalePopulation, Color(0xFF60AD77)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopulationBox(String label, int population, Color color) {
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1),
          Text(
            population.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final Icon? prefixIcon;
  final bool obscureText;

  const RoundedInputField({
    Key? key,
    required this.hintText,
    this.initialValue,
    this.onChanged,
    this.controller,
    this.prefixIcon,
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
        controller: controller,
        onChanged: onChanged,
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
